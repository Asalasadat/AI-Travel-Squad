using AiTravelSquad.Api.DTOs;
using AiTravelSquad.Domain.Entities;
using AiTravelSquad.Domain.Enums.Localization;
using AiTravelSquad.Infrastructure.Data;
using AiTravelSquad.Infrastructure.ExternalServices.AiModel;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace AiTravelSquad.Api.Controllers
{
    /// <summary>
    /// Handles tourist place recommendation requests.
    /// Delegates the actual scoring/matching logic to the AI team's
    /// Content-Based Filtering model (hosted separately), then enriches
    /// the results with data from our own database.
    /// </summary>
    [ApiController]
    [Route("api/[controller]")]
    public class RecommendationsController : ControllerBase
    {
        private readonly ApplicationDbContext _context;
        private readonly AiRecommendationClient _aiClient;

        public RecommendationsController(
            ApplicationDbContext context,
            AiRecommendationClient aiClient)
        {
            _context = context;
            _aiClient = aiClient;
        }

        [HttpPost]
        public async Task<ActionResult<RecommendationResponseDto>> PostRecommendation(
            [FromBody] RecommendationRequestDto request)
        {
            var citiesAr = request.Cities
                .Select(ArabicEnumTranslator.ToArabic)
                .ToList();

            var tripTypesAr = request.TripTypes
                .Select(ArabicEnumTranslator.ToArabic)
                .ToList();

            List<AiRecommendationItem> aiResults;

            try
            {
                aiResults = await _aiClient.GetRecommendationsAsync(
                    new AiRecommendationRequest
                    {
                        CitiesAr = citiesAr,
                        TripTypesAr = tripTypesAr,
                        TotalBudget = request.TotalBudget,
                        PeopleOverTen = request.PeopleOverTen,
                        TopN = 10
                    });
            }
            catch (HttpRequestException ex)
            {
                return StatusCode(502, new
                {
                    status = 502,
                    message = "The recommendation service is currently unavailable. Please try again shortly.",
                    detail = ex.Message
                });
            }

            if (!aiResults.Any())
            {
                return NotFound(new
                {
                    status = 404,
                    message = "No places match the given preferences and budget."
                });
            }

            // Match AI results with local Places table.
            var placeNamesArTrimmed = aiResults
                .Where(r => r.PlaceNameAr != null)
                .Select(r => r.PlaceNameAr!.Trim())
                .Distinct()
                .ToList();

            // Only retrieve matching places from the database.
            var matchedPlaces = await _context.Places
                .AsNoTracking()
                .Where(p =>
                    p.PlaceNameAr != null &&
                    placeNamesArTrimmed.Contains(p.PlaceNameAr))
                .ToListAsync();

            // Persist the request.
            var recommendationRequest = new RecommendationRequest
            {
                UserId = User?.Identity?.Name ?? "anonymous",
                City = string.Join(", ", request.Cities),
                TripType = string.Join(", ", request.TripTypes),
                AgeGroup = "N/A",
                GroupSize = request.PeopleOverTen,
                BudgetLevel = request.TotalBudget.ToString("0")
            };

            _context.RecommendationRequests.Add(
                recommendationRequest
            );

            await _context.SaveChangesAsync();

            var recommendationDtos =
                new List<PlaceRecommendationDto>();

            var results =
                new List<RecommendationResult>();

            for (int i = 0; i < aiResults.Count; i++)
            {
                var aiItem = aiResults[i];

                var matchedPlace = matchedPlaces.FirstOrDefault(p =>
                    p.PlaceNameAr != null &&
                    aiItem.PlaceNameAr != null &&
                    p.PlaceNameAr.Trim() ==
                    aiItem.PlaceNameAr.Trim()
                );

                recommendationDtos.Add(
                    new PlaceRecommendationDto
                    {
                        PlaceId = matchedPlace?.Id ?? 0,

                        PlaceName =
                            aiItem.PlaceNameAr ?? string.Empty,

                        PlaceType =
                            matchedPlace?.PlaceType ??
                            aiItem.TripType ??
                            string.Empty,

                        City =
                            aiItem.City ?? string.Empty,

                        Description =
                            aiItem.DescriptionAr,

                        MatchScore =
                            Math.Round(
                                aiItem.RecommendationScore,
                                2
                            ),

                        RankOrder = i + 1
                    }
                );

                // Persist only matched places.
                if (matchedPlace != null)
                {
                    results.Add(
                        new RecommendationResult
                        {
                            RecommendationRequestId =
                                recommendationRequest.Id,

                            PlaceId =
                                matchedPlace.Id,

                            MatchScore =
                                Math.Round(
                                    aiItem.RecommendationScore,
                                    2
                                ),

                            RankOrder = i + 1
                        }
                    );
                }
            }

            if (results.Any())
            {
                _context.RecommendationResults.AddRange(
                    results
                );

                await _context.SaveChangesAsync();
            }

            var response = new RecommendationResponseDto
            {
                RecommendationRequestId =
                    recommendationRequest.Id,

                Recommendations =
                    recommendationDtos
            };

            return Ok(response);
        }
    }
}
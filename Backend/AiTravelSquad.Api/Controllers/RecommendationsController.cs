using AiTravelSquad.Api.DTOs;
using AiTravelSquad.Domain.Entities;
using AiTravelSquad.Infrastructure.Data;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace AiTravelSquad.Api.Controllers
{
    /// <summary>
    /// Handles tourist place recommendation requests.
    /// Currently uses a simple rule-based scoring system as a placeholder.
    /// This will later be replaced (or complemented) by calling the AI team's
    /// Scikit-learn Content-Based Filtering model, once it's ready.
    /// </summary>
    [ApiController]
    [Route("api/[controller]")]
    public class RecommendationsController : ControllerBase
    {
        private readonly ApplicationDbContext _context;

        public RecommendationsController(ApplicationDbContext context)
        {
            _context = context;
        }

        /// <summary>
        /// Generates a ranked list of recommended tourist places based on
        /// the user's preferences (city, trip type, age group, budget level).
        /// </summary>
        /// <remarks>
        /// Scoring logic (placeholder, to be replaced by the AI model):
        /// - +2 points if the city matches exactly
        /// - +1 point if the trip type matches
        /// - +1 point if the age group matches
        /// - +1 point if the budget level matches
        /// Max possible score = 5. We normalize it to a 0-1 range to match
        /// the "MatchScore" format expected from the AI model.
        /// Only places scoring above 0 are considered, sorted best-first,
        /// and capped between 5 and 10 results as required by the project spec.
        /// </remarks>
        [HttpPost]
        public async Task<ActionResult<RecommendationResponseDto>> PostRecommendation(
            [FromBody] RecommendationRequestDto request)
        {
            // Basic validation happens automatically via [Required]/[Range] on the DTO.
            // We still guard against an empty Places table (e.g. before seeding/migration).
            var allPlaces = await _context.Places.ToListAsync();

            if (!allPlaces.Any())
            {
                return NotFound("No places available yet. Please seed the database first.");
            }

            const decimal maxScore = 5m;

            // Score every place against the user's preferences.
            var scoredPlaces = allPlaces
                .Select(place =>
                {
                    decimal score = 0;

                    if (string.Equals(place.City, request.City, StringComparison.OrdinalIgnoreCase))
                        score += 2;

                    if (string.Equals(place.TripType, request.TripType, StringComparison.OrdinalIgnoreCase))
                        score += 1;

                    if (string.Equals(place.AgeGroup, request.AgeGroup, StringComparison.OrdinalIgnoreCase))
                        score += 1;

                    if (string.Equals(place.BudgetLevel, request.BudgetLevel, StringComparison.OrdinalIgnoreCase))
                        score += 1;

                    return new { Place = place, Score = score };
                })
                // Keep only places with at least some relevance.
                .Where(x => x.Score > 0)
                .OrderByDescending(x => x.Score)
                // Cap results between 5 and 10 as required by the project spec.
                .Take(10)
                .ToList();

            // Fallback: if fewer than 5 places matched, fill up with the
            // highest-scoring remaining places (even score = 0) so the user
            // still gets a useful list instead of an empty one.
            if (scoredPlaces.Count < 5)
            {
                var alreadyIncludedIds = scoredPlaces.Select(x => x.Place.Id).ToHashSet();

                var fillerPlaces = allPlaces
                    .Where(p => !alreadyIncludedIds.Contains(p.Id))
                    .Take(5 - scoredPlaces.Count)
                    .Select(p => new { Place = p, Score = 0m });

                scoredPlaces = scoredPlaces.Concat(fillerPlaces).ToList();
            }

            // Persist the request for history/analytics purposes.
            var recommendationRequest = new RecommendationRequest
            {
                UserId = User?.Identity?.Name ?? "anonymous", // Replace with real user id once auth is wired in
                City = request.City,
                TripType = request.TripType,
                AgeGroup = request.AgeGroup,
                GroupSize = request.GroupSize,
                BudgetLevel = request.BudgetLevel
            };

            _context.RecommendationRequests.Add(recommendationRequest);
            await _context.SaveChangesAsync();

            // Build and persist the individual results, preserving rank order.
            var results = scoredPlaces
                .Select((x, index) => new RecommendationResult
                {
                    RecommendationRequestId = recommendationRequest.Id,
                    PlaceId = x.Place.Id,
                    MatchScore = Math.Round(x.Score / maxScore, 2),
                    RankOrder = index + 1
                })
                .ToList();

            _context.RecommendationResults.AddRange(results);
            await _context.SaveChangesAsync();

            // Shape the response DTO expected by the frontend/mobile teams.
            var response = new RecommendationResponseDto
            {
                RecommendationRequestId = recommendationRequest.Id,
                Recommendations = scoredPlaces.Select((x, index) => new PlaceRecommendationDto
                {
                    PlaceId = x.Place.Id,
                    PlaceName = x.Place.PlaceName,
                    PlaceType = x.Place.PlaceType,
                    City = x.Place.City,
                    Description = x.Place.Description,
                    MatchScore = Math.Round(x.Score / maxScore, 2),
                    RankOrder = index + 1
                }).ToList()
            };

            return Ok(response);
        }
    }
}

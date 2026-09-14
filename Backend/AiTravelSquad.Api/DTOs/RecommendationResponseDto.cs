namespace AiTravelSquad.Api.DTOs
{
    /// <summary>
    /// The full response returned by POST /api/recommendations.
    /// Wraps the list of recommended places (5 to 10 items) together
    /// with some metadata about the request that produced them.
    /// </summary>
    public class RecommendationResponseDto
    {
        /// <summary>Id of the stored recommendation request (for history/tracking)</summary>
        public int RecommendationRequestId { get; set; }

        /// <summary>List of recommended places, ordered from best to least match</summary>
        public List<PlaceRecommendationDto> Recommendations { get; set; } = new();

        /// <summary>Total number of places returned (should be between 5 and 10)</summary>
        public int TotalResults => Recommendations.Count;
    }
}

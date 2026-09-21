namespace AiTravelSquad.Infrastructure.ExternalServices.AiModel
{
    /// <summary>
    /// Wraps the top-level "recommendations" array from the AI API's response.
    /// </summary>
    public class AiRecommendationResponse
    {
        public List<AiRecommendationItem> Recommendations { get; set; } = new();
    }
}

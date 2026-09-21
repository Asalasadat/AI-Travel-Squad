using System.Text.Json.Serialization;

namespace AiTravelSquad.Infrastructure.ExternalServices.AiModel
{
    /// <summary>
    /// A single recommended place as returned by the AI team's API.
    /// Property names use [JsonPropertyName] because their API returns
    /// PascalCase/underscore keys (e.g. "Place_Name_AR") instead of standard
    /// camelCase or snake_case.
    /// </summary>
    public class AiRecommendationItem
    {
        [JsonPropertyName("Place_Name_AR")]
        public string? PlaceNameAr { get; set; }

        [JsonPropertyName("Description_AR")]
        public string? DescriptionAr { get; set; }

        [JsonPropertyName("City")]
        public string? City { get; set; }

        [JsonPropertyName("Trip_Type")]
        public string? TripType { get; set; }

        [JsonPropertyName("Estimated_Cost_ILS")]
        public decimal EstimatedCostIls { get; set; }

        [JsonPropertyName("Total_Cost_ILS")]
        public decimal TotalCostIls { get; set; }

        [JsonPropertyName("Recommendation_Score")]
        public decimal RecommendationScore { get; set; }
    }
}

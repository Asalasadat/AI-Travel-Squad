using System.Text.Json.Serialization;

namespace AiTravelSquad.Infrastructure.ExternalServices.AiModel
{
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

        [JsonPropertyName("Similarity_Score")]
        public decimal SimilarityScore { get; set; }
    }
}

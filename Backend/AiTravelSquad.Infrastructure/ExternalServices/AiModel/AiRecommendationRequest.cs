using System.Text.Json.Serialization;

namespace AiTravelSquad.Infrastructure.ExternalServices.AiModel
{
    /// <summary>
    /// Request body sent to the AI team's Render-hosted API (POST /recommendations).
    /// Field names use explicit [JsonPropertyName] because the automatic
    /// snake_case naming policy would produce "people_over_ten" instead of
    /// the API's actual expected field "people_over_10" (with a numeral).
    /// </summary>
    public class AiRecommendationRequest
    {
        [JsonPropertyName("cities_ar")]
        public List<string> CitiesAr { get; set; } = new();

        [JsonPropertyName("trip_types_ar")]
        public List<string> TripTypesAr { get; set; } = new();

        [JsonPropertyName("ages_ar")]
        public List<string> AgeGroupAr { get; set; } = new();

        [JsonPropertyName("total_budget")]
        public decimal TotalBudget { get; set; }

        [JsonPropertyName("people_over_10")]
        public int PeopleOverTen { get; set; }

        [JsonPropertyName("top_n")]
        public int TopN { get; set; } = 10;
    }
}


using System.ComponentModel.DataAnnotations;
using System.Text.Json.Serialization;
using AiTravelSquad.Domain.Enums;

namespace AiTravelSquad.Api.DTOs
{
    /// <summary>
    /// Data sent by the client (frontend/mobile) when requesting recommendations.
    /// Field names use [JsonPropertyName] to match exactly what the frontend team's
    /// preferences.html sends (PascalCase: "Cities", "TripTypes", "Budget", "GroupSize"),
    /// since the frontend was already built and tested against these exact names.
    /// </summary>
    public class RecommendationRequestDto
    {
        [JsonPropertyName("Cities")]
        [Required]
        [MinLength(1, ErrorMessage = "Select at least one city.")]
        public List<City> Cities { get; set; } = new();

        [JsonPropertyName("TripTypes")]
        [Required]
        [MinLength(1, ErrorMessage = "Select at least one trip type.")]
        public List<TripType> TripTypes { get; set; } = new();

        /// <summary>
        /// Total trip budget in ILS. Frontend sends this as "Budget".
        /// </summary>
        [JsonPropertyName("Budget")]
        [Range(1, double.MaxValue, ErrorMessage = "Total budget must be greater than 0.")]
        public decimal TotalBudget { get; set; }

        /// <summary>
        /// Number of travelers over 10 years old. Frontend sends this as "GroupSize".
        /// </summary>
        [JsonPropertyName("GroupSize")]
        [Range(1, 50, ErrorMessage = "Number of people must be between 1 and 50.")]
        public int PeopleOverTen { get; set; }
    }
}

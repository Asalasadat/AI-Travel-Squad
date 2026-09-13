using System.ComponentModel.DataAnnotations;

namespace AiTravelSquad.Api.DTOs
{
    /// <summary>
    /// Data sent by the client (frontend/mobile) when requesting recommendations.
    /// This shape is what the user fills in the app: city, trip type, age group,
    /// group size, and budget level. This is exactly what the AI model needs
    /// to run the Content-Based Filtering comparison against the Places dataset.
    /// </summary>
    public class RecommendationRequestDto
    {
        /// <summary>City the user wants to visit (e.g. "Nablus")</summary>
        [Required]
        [MaxLength(50)]
        public string City { get; set; } = string.Empty;

        /// <summary>Trip type preference: "Family" or "Youth"</summary>
        [Required]
        [MaxLength(30)]
        public string TripType { get; set; } = string.Empty;

        /// <summary>Age group of the traveler(s)</summary>
        [Required]
        [MaxLength(30)]
        public string AgeGroup { get; set; } = string.Empty;

        /// <summary>Number of people traveling together</summary>
        [Range(1, 100, ErrorMessage = "Group size must be between 1 and 100.")]
        public int GroupSize { get; set; }

        /// <summary>Budget level: "Low", "Medium", or "High"</summary>
        [Required]
        [MaxLength(20)]
        public string BudgetLevel { get; set; } = string.Empty;
    }
}

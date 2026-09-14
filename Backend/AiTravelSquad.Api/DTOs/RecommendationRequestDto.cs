using System.ComponentModel.DataAnnotations;
using AiTravelSquad.Domain.Enums;

namespace AiTravelSquad.Api.DTOs
{
    /// <summary>
    /// Data sent by the client (frontend/mobile) when requesting recommendations.
    /// Fields use enums instead of free text for security and correctness:
    /// - Prevents SQL/input injection since only predefined values are accepted
    ///   (the model binder rejects any value that isn't a valid enum member,
    ///   returning 400 Bad Request automatically before the controller runs).
    /// - Guarantees the values sent by the client match exactly the values
    ///   that exist in the AI team's dataset (City, BudgetLevel, AgeGroup, TripType columns),
    ///   which is required for correct mapping to the recommendation model's inputs.
    /// GroupSize stays numeric with an explicit upper bound to prevent unreasonable input.
    /// </summary>
    public class RecommendationRequestDto
    {
        /// <summary>City the user wants to visit</summary>
        [Required]
        public City City { get; set; }

        /// <summary>Trip type preference</summary>
        [Required]
        public TripType TripType { get; set; }

        /// <summary>Age group of the traveler(s)</summary>
        [Required]
        public AgeGroup AgeGroup { get; set; }

        /// <summary>
        /// Number of people traveling together.
        /// Capped at 50 to prevent unreasonable/malicious input (per security review).
        /// </summary>
        [Range(1, 50, ErrorMessage = "Group size must be between 1 and 50.")]
        public int GroupSize { get; set; }

        /// <summary>Budget level preference</summary>
        [Required]
        public BudgetLevel BudgetLevel { get; set; }
    }
}

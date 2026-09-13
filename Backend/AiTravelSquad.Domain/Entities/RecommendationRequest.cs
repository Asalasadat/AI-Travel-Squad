using System.ComponentModel.DataAnnotations;

namespace AiTravelSquad.Domain.Entities
{
    /// <summary>
    /// Represents a single recommendation request submitted by a user.
    /// We store this request to keep a historical record of all requests,
    /// which later makes it easier to analyze user behavior or improve the model.
    /// Note: UserId is a plain string here without a direct ForeignKey to Identity,
    /// because the Identity table will be linked inside the Infrastructure project
    /// where the DbContext lives. This keeps the Domain project independent
    /// from any authentication-related details.
    /// </summary>
    public class RecommendationRequest
    {
        [Key]
        public int Id { get; set; }

        /// <summary>Id of the user who made the request</summary>
        [Required]
        public string UserId { get; set; } = string.Empty;

        /// <summary>City preference selected by the user</summary>
        [Required]
        [MaxLength(50)]
        public string City { get; set; } = string.Empty;

        /// <summary>Preferred trip type</summary>
        [Required]
        [MaxLength(30)]
        public string TripType { get; set; } = string.Empty;

        /// <summary>Age group of the user or group</summary>
        [Required]
        [MaxLength(30)]
        public string AgeGroup { get; set; } = string.Empty;

        /// <summary>Number of people participating in the trip</summary>
        [Range(1, 100)]
        public int GroupSize { get; set; }

        /// <summary>Budget level available to the user</summary>
        [Required]
        [MaxLength(20)]
        public string BudgetLevel { get; set; } = string.Empty;

        /// <summary>Timestamp when the request was submitted (filled automatically)</summary>
        public DateTime RequestedAt { get; set; } = DateTime.UtcNow;

        // ---- Navigation Property ----
        // Each recommendation request returns between 5 and 10 results
        public ICollection<RecommendationResult> Results { get; set; }
            = new List<RecommendationResult>();
    }
}

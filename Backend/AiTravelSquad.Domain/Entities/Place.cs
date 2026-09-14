using System.ComponentModel.DataAnnotations;

namespace AiTravelSquad.Domain.Entities
{
    /// <summary>
    /// Represents a single tourist place stored in the database.
    /// This table is the main data source used by the AI model
    /// when performing Content-Based Filtering.
    /// Columns match the real dataset collected by the AI team
    /// (palestine_tourist_attractions_v2.csv).
    /// </summary>
    public class Place
    {
        [Key]
        public int Id { get; set; }

        /// <summary>Official name of the tourist site</summary>
        [Required]
        [MaxLength(150)]
        public string PlaceName { get; set; } = string.Empty;

        /// <summary>City where the place is located (e.g. Nablus, Bethlehem)</summary>
        [Required]
        [MaxLength(50)]
        public string City { get; set; } = string.Empty;

        /// <summary>Type of place: Religious / Historic / Archaeological ...</summary>
        [Required]
        [MaxLength(50)]
        public string PlaceType { get; set; } = string.Empty;

        /// <summary>Budget level suitable for visiting this place: Low / Medium / High</summary>
        [Required]
        [MaxLength(20)]
        public string BudgetLevel { get; set; } = string.Empty;

        /// <summary>Best trip type for this place: Family / Youth / Religious / Cultural / Adventure ...</summary>
        [Required]
        [MaxLength(30)]
        public string TripType { get; set; } = string.Empty;

        /// <summary>Best age group for this place</summary>
        [Required]
        [MaxLength(30)]
        public string AgeGroup { get; set; } = string.Empty;

        /// <summary>Short description to help the user understand the place</summary>
        [MaxLength(1000)]
        public string? Description { get; set; }

        /// <summary>Latitude coordinate, sourced from the AI team's dataset</summary>
        public double? Latitude { get; set; }

        /// <summary>Longitude coordinate, sourced from the AI team's dataset</summary>
        public double? Longitude { get; set; }

        /// <summary>Estimated visiting cost in Israeli Shekel (ILS), used for budget-based scoring</summary>
        public int? EstimatedCostIls { get; set; }

        /// <summary>Record creation date (filled automatically)</summary>
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;

        // ---- Navigation Property ----
        // A place can appear in multiple recommendation results over time
        public ICollection<RecommendationResult> RecommendationResults { get; set; }
            = new List<RecommendationResult>();
    }
}

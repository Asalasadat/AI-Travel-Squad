using System.ComponentModel.DataAnnotations;

namespace AiTravelSquad.Domain.Entities
{
    /// <summary>
    /// Represents a single tourist place stored in the database.
    /// Columns match the v3 dataset (palestine_tourist_attractions_v3_ar_and_en.csv),
    /// which adds Arabic name/description fields needed to match results
    /// returned by the AI model's Arabic-only recommendation API.
    /// </summary>
    public class Place
    {
        [Key]
        public int Id { get; set; }

        /// <summary>Official name of the tourist site (English)</summary>
        [Required]
        [MaxLength(150)]
        public string PlaceName { get; set; } = string.Empty;

        /// <summary>
        /// Official name of the tourist site (Arabic).
        /// This is the field used to match results coming back from the
        /// AI recommendation API, since that API works entirely in Arabic.
        /// </summary>
        [MaxLength(150)]
        public string? PlaceNameAr { get; set; }

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

        /// <summary>Short description to help the user understand the place (English)</summary>
        [MaxLength(1000)]
        public string? Description { get; set; }

        /// <summary>Short description in Arabic (returned to the frontend for Arabic UI)</summary>
        [MaxLength(1000)]
        public string? DescriptionAr { get; set; }

        /// <summary>Image URL of the tourist place</summary>
      [MaxLength(2000)]
public string? ImageUrl { get; set; }

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

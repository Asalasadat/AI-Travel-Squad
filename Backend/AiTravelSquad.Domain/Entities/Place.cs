using System.ComponentModel.DataAnnotations;

namespace AiTravelSquad.Domain.Entities
{
    /// <summary>
    /// Represents a single tourist place stored in the database.
    /// This table is the main data source used by the AI model
    /// when performing Content-Based Filtering.
    /// The columns here match exactly the CSV file prepared by the AI team,
    /// to make the import process straightforward without extra transformations.
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

        /// <summary>Type of place: touristic / heritage / natural / religious ...</summary>
        [Required]
        [MaxLength(50)]
        public string PlaceType { get; set; } = string.Empty;

        /// <summary>Budget level suitable for visiting this place: low / medium / high</summary>
        [Required]
        [MaxLength(20)]
        public string BudgetLevel { get; set; } = string.Empty;

        /// <summary>Best trip type for this place: family / youth</summary>
        [Required]
        [MaxLength(30)]
        public string TripType { get; set; } = string.Empty;

        /// <summary>Best age group for this place</summary>
        [Required]
        [MaxLength(30)]
        public string AgeGroup { get; set; } = string.Empty;

        /// <summary>Short description to help the user understand the place</summary>
        [MaxLength(500)]
        public string? Description { get; set; }

        /// <summary>Record creation date (filled automatically)</summary>
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;

        // ---- Navigation Property ----
        // A place can appear in multiple recommendation results over time
        public ICollection<RecommendationResult> RecommendationResults { get; set; }
            = new List<RecommendationResult>();
    }
}

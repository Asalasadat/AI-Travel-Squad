using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace AiTravelSquad.Domain.Entities
{
    /// <summary>
    /// Join table between RecommendationRequest and Place.
    /// Each row represents one "place" within the results of one "recommendation request",
    /// along with its match score and rank order as returned by the AI model.
    /// </summary>
    public class RecommendationResult
    {
        [Key]
        public int Id { get; set; }

        /// <summary>The request this result belongs to (Foreign Key)</summary>
        [Required]
        public int RecommendationRequestId { get; set; }

        [ForeignKey(nameof(RecommendationRequestId))]
        public RecommendationRequest? RecommendationRequest { get; set; }

        /// <summary>The recommended place for this result (Foreign Key)</summary>
        [Required]
        public int PlaceId { get; set; }

        [ForeignKey(nameof(PlaceId))]
        public Place? Place { get; set; }

        /// <summary>
        /// Match score returned by the AI model (Content-Based Filtering).
        /// Represents how well this place fits the user's preferences, typically between 0 and 1.
        /// </summary>
        [Column(TypeName = "decimal(5,2)")]
        public decimal MatchScore { get; set; }

        /// <summary>Rank of the place within the results list (1 = best match)</summary>
        public int RankOrder { get; set; }
    }
}

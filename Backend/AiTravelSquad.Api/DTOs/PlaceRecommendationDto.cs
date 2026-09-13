namespace AiTravelSquad.Api.DTOs
{
    /// <summary>
    /// Represents a single recommended place returned to the client.
    /// This is the shape described in the project summary: name, type,
    /// a short description, and a match score showing how well it fits
    /// the user's preferences.
    /// </summary>
    public class PlaceRecommendationDto
    {
        public int PlaceId { get; set; }

        /// <summary>Official name of the tourist site</summary>
        public string PlaceName { get; set; } = string.Empty;

        /// <summary>Type of place: touristic / heritage / natural / religious ...</summary>
        public string PlaceType { get; set; } = string.Empty;

        /// <summary>City where the place is located</summary>
        public string City { get; set; } = string.Empty;

        /// <summary>Short description to help the user understand the place</summary>
        public string? Description { get; set; }

        /// <summary>
        /// Match score between 0 and 1 showing how well this place fits
        /// the user's stated preferences. Returned by the AI model
        /// (or by the placeholder scoring logic until AI integration is ready).
        /// </summary>
        public decimal MatchScore { get; set; }

        /// <summary>Rank of this place within the results (1 = best match)</summary>
        public int RankOrder { get; set; }
    }
}

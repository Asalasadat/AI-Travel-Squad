using CsvHelper.Configuration.Attributes;

namespace AiTravelSquad.Infrastructure.SeedData.Csv
{
    /// <summary>
    /// Represents a single row exactly as it appears in
    /// palestine_tourist_attractions_v2.csv (prepared by the AI team).
    /// The [Name] attributes map each property to its actual CSV column header,
    /// since the CSV headers don't match our internal property naming convention.
    /// </summary>
    public class CsvPlaceRecord
    {
        [Name("ID")]
        public int Id { get; set; }

        [Name("Place_Name")]
        public string PlaceName { get; set; } = string.Empty;

        [Name("type")]
        public string PlaceType { get; set; } = string.Empty;

        [Name("City")]
        public string City { get; set; } = string.Empty;

        [Name("Budget_Level")]
        public string BudgetLevel { get; set; } = string.Empty;

        [Name("Age_Group")]
        public string AgeGroup { get; set; } = string.Empty;

        [Name("Trip_Type")]
        public string TripType { get; set; } = string.Empty;

        [Name("Description")]
        public string? Description { get; set; }

        [Name("Latitude")]
        public double? Latitude { get; set; }

        [Name("Longitude")]
        public double? Longitude { get; set; }

        // Coordinate_Source and Geocode_Status columns are metadata about
        // how the AI team collected the coordinates; not needed in our database.

        [Name("Estimated_Cost_ILS")]
        public int? EstimatedCostIls { get; set; }
    }
}

using CsvHelper.Configuration.Attributes;

namespace AiTravelSquad.Infrastructure.SeedData.Csv
{
    /// <summary>
    /// Represents a single row exactly as it appears in
    /// palestine_tourist_attractions_v3_ar_and_en.csv (prepared by the AI team).
    /// The [Name] attributes map each property to its actual CSV column header.
    /// </summary>
    public class CsvPlaceRecord
    {
        [Name("ID")]
        public int Id { get; set; }

        [Name("Place_Name")]
        public string PlaceName { get; set; } = string.Empty;

        [Name("Place_Name_AR")]
        public string? PlaceNameAr { get; set; }

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

        [Name("Description_AR")]
        public string? DescriptionAr { get; set; }

        [Name("Latitude")]
        public double? Latitude { get; set; }

        [Name("Longitude")]
        public double? Longitude { get; set; }

        [Name("Estimated_Cost_ILS")]
        public int? EstimatedCostIls { get; set; }
    }
}

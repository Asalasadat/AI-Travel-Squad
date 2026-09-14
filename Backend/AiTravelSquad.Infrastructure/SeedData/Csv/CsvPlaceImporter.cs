using CsvHelper;
using CsvHelper.Configuration;
using AiTravelSquad.Domain.Entities;
using System.Globalization;

namespace AiTravelSquad.Infrastructure.SeedData.Csv
{
    /// <summary>
    /// Reads the AI team's CSV dataset and converts each row into a Place entity
    /// ready to be inserted into the database.
    /// </summary>
    public static class CsvPlaceImporter
    {
        public static List<Place> ImportFromCsv(string filePath)
        {
            using var reader = new StreamReader(filePath);

            var config = new CsvConfiguration(CultureInfo.InvariantCulture)
            {
                // Some description fields contain commas inside quotes; CsvHelper
                // handles standard CSV quoting by default, so no extra config needed here.
                HeaderValidated = null,
                MissingFieldFound = null
            };

            using var csv = new CsvReader(reader, config);
            var records = csv.GetRecords<CsvPlaceRecord>().ToList();

            return records.Select(r => new Place
            {
                PlaceName = r.PlaceName,
                City = r.City,
                PlaceType = r.PlaceType,
                BudgetLevel = r.BudgetLevel,
                TripType = r.TripType,
                AgeGroup = r.AgeGroup,
                Description = r.Description,
                Latitude = r.Latitude,
                Longitude = r.Longitude,
                EstimatedCostIls = r.EstimatedCostIls
            }).ToList();
        }
    }
}

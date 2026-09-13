using AiTravelSquad.Domain.Entities;

namespace AiTravelSquad.Infrastructure.SeedData
{
    /// <summary>
    /// Provides sample tourist places used to seed the database during development.
    /// This lets the team test the /api/recommendations endpoint end-to-end
    /// before the AI team finishes collecting the full dataset (50-150 places).
    /// The columns here match exactly the schema agreed with the AI team:
    /// Place_Name, City, Place_Type, Budget_Level, Trip_Type, Age_Group.
    /// </summary>
    public static class PlaceSeedData
    {
        public static List<Place> GetSeedPlaces()
        {
            return new List<Place>
            {
                new Place
                {
                    PlaceName = "Old City of Nablus",
                    City = "Nablus",
                    PlaceType = "Heritage",
                    BudgetLevel = "Low",
                    TripType = "Family",
                    AgeGroup = "All Ages",
                    Description = "Historic old town known for its markets, soap factories, and Ottoman-era architecture."
                },
                new Place
                {
                    PlaceName = "Church of the Nativity",
                    City = "Bethlehem",
                    PlaceType = "Religious",
                    BudgetLevel = "Low",
                    TripType = "Family",
                    AgeGroup = "All Ages",
                    Description = "One of the oldest churches in the world, built over the traditional birthplace of Jesus."
                },
                new Place
                {
                    PlaceName = "Al-Aqsa Mosque",
                    City = "Jerusalem",
                    PlaceType = "Religious",
                    BudgetLevel = "Low",
                    TripType = "Family",
                    AgeGroup = "All Ages",
                    Description = "Third holiest site in Islam, located within the Old City of Jerusalem."
                },
                new Place
                {
                    PlaceName = "Wadi Qelt",
                    City = "Jericho",
                    PlaceType = "Natural",
                    BudgetLevel = "Low",
                    TripType = "Youth",
                    AgeGroup = "Adults",
                    Description = "Scenic canyon popular for hiking, with views of St. George Monastery."
                },
                new Place
                {
                    PlaceName = "Hisham's Palace",
                    City = "Jericho",
                    PlaceType = "Heritage",
                    BudgetLevel = "Low",
                    TripType = "Family",
                    AgeGroup = "All Ages",
                    Description = "Umayyad-era archaeological site featuring an impressive mosaic floor."
                },
                new Place
                {
                    PlaceName = "Taybeh Brewery",
                    City = "Ramallah",
                    PlaceType = "Recreational",
                    BudgetLevel = "Medium",
                    TripType = "Youth",
                    AgeGroup = "Adults",
                    Description = "The Middle East's first microbrewery, offering tours and tastings in Taybeh village."
                },
                new Place
                {
                    PlaceName = "Rawabi City",
                    City = "Ramallah",
                    PlaceType = "Recreational",
                    BudgetLevel = "Medium",
                    TripType = "Youth",
                    AgeGroup = "Youth",
                    Description = "Modern planned city with a Q Center for shopping, dining, and entertainment."
                },
                new Place
                {
                    PlaceName = "Sebastia Archaeological Site",
                    City = "Nablus",
                    PlaceType = "Heritage",
                    BudgetLevel = "Low",
                    TripType = "Family",
                    AgeGroup = "All Ages",
                    Description = "Ancient ruins spanning Roman, Byzantine, and Ottoman periods with panoramic views."
                },
                new Place
                {
                    PlaceName = "Solomon's Pools",
                    City = "Bethlehem",
                    PlaceType = "Heritage",
                    BudgetLevel = "Low",
                    TripType = "Family",
                    AgeGroup = "All Ages",
                    Description = "Ancient reservoirs historically used to supply water to Jerusalem and Bethlehem."
                },
                new Place
                {
                    PlaceName = "Ein Gedi-style Springs of Al-Auja",
                    City = "Jericho",
                    PlaceType = "Natural",
                    BudgetLevel = "Low",
                    TripType = "Family",
                    AgeGroup = "All Ages",
                    Description = "Natural freshwater springs popular for swimming and picnics, especially in summer."
                },
                new Place
                {
                    PlaceName = "Tent of Nations",
                    City = "Bethlehem",
                    PlaceType = "Natural",
                    BudgetLevel = "Low",
                    TripType = "Family",
                    AgeGroup = "All Ages",
                    Description = "A farm promoting sustainable agriculture and peace education, open to visitors."
                },
                new Place
                {
                    PlaceName = "Mount Gerizim",
                    City = "Nablus",
                    PlaceType = "Natural",
                    BudgetLevel = "Low",
                    TripType = "Family",
                    AgeGroup = "All Ages",
                    Description = "Sacred mountain to the Samaritan community, offering hiking trails and city views."
                },
                new Place
                {
                    PlaceName = "Qalandia Cultural Center",
                    City = "Ramallah",
                    PlaceType = "Cultural",
                    BudgetLevel = "Low",
                    TripType = "Youth",
                    AgeGroup = "Youth",
                    Description = "Local art and cultural events hub showcasing Palestinian creativity."
                },
                new Place
                {
                    PlaceName = "Al-Rashidieh Souq",
                    City = "Hebron",
                    PlaceType = "Cultural",
                    BudgetLevel = "Low",
                    TripType = "Family",
                    AgeGroup = "All Ages",
                    Description = "Traditional market in the old city known for pottery, glassware, and local crafts."
                },
                new Place
                {
                    PlaceName = "Ibrahimi Mosque",
                    City = "Hebron",
                    PlaceType = "Religious",
                    BudgetLevel = "Low",
                    TripType = "Family",
                    AgeGroup = "All Ages",
                    Description = "Sacred site revered by Muslims and Jews, built over the Cave of the Patriarchs."
                },
                new Place
                {
                    PlaceName = "Canaan Fair Trade Farm Tour",
                    City = "Jenin",
                    PlaceType = "Recreational",
                    BudgetLevel = "Medium",
                    TripType = "Family",
                    AgeGroup = "All Ages",
                    Description = "Olive farm tours showcasing traditional and organic olive oil production."
                },
                new Place
                {
                    PlaceName = "Burqin Church",
                    City = "Jenin",
                    PlaceType = "Religious",
                    BudgetLevel = "Low",
                    TripType = "Family",
                    AgeGroup = "All Ages",
                    Description = "One of the oldest churches in the world, associated with the healing of ten lepers."
                },
                new Place
                {
                    PlaceName = "Gaza Beach Promenade",
                    City = "Gaza",
                    PlaceType = "Natural",
                    BudgetLevel = "Low",
                    TripType = "Family",
                    AgeGroup = "All Ages",
                    Description = "Mediterranean coastline with cafes and family-friendly beach spots."
                },
                new Place
                {
                    PlaceName = "Yasser Arafat Museum",
                    City = "Ramallah",
                    PlaceType = "Cultural",
                    BudgetLevel = "Medium",
                    TripType = "Family",
                    AgeGroup = "Adults",
                    Description = "Museum documenting modern Palestinian history and the life of Yasser Arafat."
                },
                new Place
                {
                    PlaceName = "Battir Terraces",
                    City = "Bethlehem",
                    PlaceType = "Natural",
                    BudgetLevel = "Low",
                    TripType = "Youth",
                    AgeGroup = "Adults",
                    Description = "UNESCO World Heritage terraced landscape with ancient irrigation systems, great for hiking."
                }
            };
        }
    }
}

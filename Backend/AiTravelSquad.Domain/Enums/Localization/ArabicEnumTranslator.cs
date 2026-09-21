using AiTravelSquad.Domain.Enums;

namespace AiTravelSquad.Domain.Enums.Localization
{
    /// <summary>
    /// Translates our English-based enums into the exact Arabic strings
    /// expected by the AI recommendation model.
    /// </summary>
    public static class ArabicEnumTranslator
    {
        private static readonly Dictionary<City, string> CityMap = new()
        {
            [City.Qalqilya] = "قلقيلية",
            [City.Tubas] = "طوباس",
            [City.Jenin] = "جنين",
            [City.Tulkarm] = "طولكرم",
            [City.Nablus] = "نابلس",
            [City.Jerusalem] = "القدس",
            [City.Bethlehem] = "بيت لحم",
            [City.Jericho] = "أريحا",
            [City.Hebron] = "الخليل",
            [City.Ramallah] = "رام الله"
        };

        private static readonly Dictionary<TripType, string> TripTypeMap = new()
        {
            [TripType.Religious] = "ديني",
            [TripType.Cultural] = "ثقافي",
            [TripType.Adventure] = "مغامرة",
            [TripType.Family] = "عائلي",
            [TripType.Relaxing] = "استرخاء",
            [TripType.Educational] = "تعليمي"
        };

        private static readonly Dictionary<AgeGroup, string> AgeGroupMap = new()
        {
            [AgeGroup.All] = "الجميع",
            [AgeGroup.Family] = "عائلة",
            [AgeGroup.Youth] = "شباب"
        };

        public static string ToArabic(City city) => CityMap[city];

        public static string ToArabic(TripType tripType) => TripTypeMap[tripType];

        public static string ToArabic(AgeGroup ageGroup) => AgeGroupMap[ageGroup];
    }
}

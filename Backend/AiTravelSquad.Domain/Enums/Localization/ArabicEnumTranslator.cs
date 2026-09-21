using AiTravelSquad.Domain.Enums;

namespace AiTravelSquad.Domain.Enums.Localization
{
    /// <summary>
    /// Translates our English-based enums (used internally and with the
    /// frontend's English contract) into the exact Arabic strings the
    /// AI team's model expects, since their API and dataset work in Arabic
    /// for these categorical inputs.
    /// </summary>
    public static class ArabicEnumTranslator
    {
        private static readonly Dictionary<City, string> CityMap = new()
        {
            [Domain.Enums.City.Qalqilya] = "قلقيلية",
            [Domain.Enums.City.Tubas] = "طوباس",
            [Domain.Enums.City.Jenin] = "جنين",
            [Domain.Enums.City.Tulkarm] = "طولكرم",
            [Domain.Enums.City.Nablus] = "نابلس",
            [Domain.Enums.City.Jerusalem] = "القدس",
            [Domain.Enums.City.Bethlehem] = "بيت لحم",
            [Domain.Enums.City.Jericho] = "أريحا",
            [Domain.Enums.City.Hebron] = "الخليل",
            [Domain.Enums.City.Ramallah] = "رام الله"
        };

        private static readonly Dictionary<TripType, string> TripTypeMap = new()
        {
            [Domain.Enums.TripType.Religious] = "ديني",
            [Domain.Enums.TripType.Cultural] = "ثقافي",
            [Domain.Enums.TripType.Adventure] = "مغامرة",
            [Domain.Enums.TripType.Family] = "عائلي",
            [Domain.Enums.TripType.Relaxing] = "استرخاء",
            [Domain.Enums.TripType.Educational] = "تعليمي"
        };

        public static string ToArabic(City city) => CityMap[city];

        public static string ToArabic(TripType tripType) => TripTypeMap[tripType];
    }
}

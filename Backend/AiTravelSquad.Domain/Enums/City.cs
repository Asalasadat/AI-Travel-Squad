namespace AiTravelSquad.Domain.Enums
{
    /// <summary>
    /// Palestinian cities covered by the tourist attractions dataset.
    /// Using an enum instead of free text prevents invalid/malicious input
    /// (e.g. SQL injection attempts) since only these exact values are accepted.
    /// </summary>
    public enum City
    {
        Bethlehem,
        Hebron,
        Jenin,
        Jericho,
        Jerusalem,
        Nablus,
        Qalqilya,
        Ramallah,
        Tubas,
        Tulkarm
    }
}

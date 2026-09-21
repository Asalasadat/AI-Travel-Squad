using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace AiTravelSquad.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class AddArabicFieldsToPlace : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "DescriptionAr",
                table: "Places",
                type: "nvarchar(1000)",
                maxLength: 1000,
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "PlaceNameAr",
                table: "Places",
                type: "nvarchar(150)",
                maxLength: 150,
                nullable: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "DescriptionAr",
                table: "Places");

            migrationBuilder.DropColumn(
                name: "PlaceNameAr",
                table: "Places");
        }
    }
}

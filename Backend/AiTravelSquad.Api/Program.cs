using AiTravelSquad.Infrastructure.Data;
using AiTravelSquad.Infrastructure.SeedData.Csv;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Text.Json.Serialization;

var builder = WebApplication.CreateBuilder(args);

// Add database context
builder.Services.AddDbContext<ApplicationDbContext>(options =>
    options.UseSqlServer(
        builder.Configuration.GetConnectionString("DefaultConnection")));

// Add Identity
builder.Services.AddIdentity<IdentityUser, IdentityRole>()
    .AddEntityFrameworkStores<ApplicationDbContext>()
    .AddDefaultTokenProviders();

// Add services to the container.
// JsonStringEnumConverter allows enums to be sent/received as readable strings
// (e.g. "Nablus") instead of raw numbers (e.g. 0).
builder.Services.AddControllers()
    .ConfigureApiBehaviorOptions(options =>
    {
        options.InvalidModelStateResponseFactory = context =>
        {
            var errors = context.ModelState
                .Where(x => x.Value?.Errors.Count > 0)
                .ToDictionary(
                    x => x.Key,
                    x =>
                    {
                        var messages = x.Value!.Errors
                            .Select(e => e.ErrorMessage)
                            .ToArray();

                        // Ignore the automatic "request field is required"
                        // message when JSON deserialization already produced
                        // a more specific error.
                        if (x.Key == "request" &&
                            context.ModelState.Keys.Any(k => k.StartsWith("$.")))
                        {
                            return Array.Empty<string>();
                        }

                        return messages;
                    })
                .Where(x => x.Value.Length > 0)
                .ToDictionary(x => x.Key, x => x.Value);

            return new BadRequestObjectResult(new
            {
                status = 400,
                message = "Invalid request data.",
                errors
            });
        };
    })
    .AddJsonOptions(options =>
    {
        options.JsonSerializerOptions.Converters.Add(
            new JsonStringEnumConverter());
    });

// Swagger / OpenAPI UI
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();

// Import the AI team's real dataset into the Places table on startup.
// Runs once: only imports if the Places table is empty.
using (var scope = app.Services.CreateScope())
{
    var dbContext = scope.ServiceProvider.GetRequiredService<ApplicationDbContext>();

    if (!dbContext.Places.Any())
    {
        var csvPath = Path.Combine(
            app.Environment.ContentRootPath,
            "..", "AiTravelSquad.Infrastructure",
            "Data", "Csv",
            "palestine_tourist_attractions_v2.csv");

        if (File.Exists(csvPath))
        {
            var places = CsvPlaceImporter.ImportFromCsv(csvPath);
            dbContext.Places.AddRange(places);
            dbContext.SaveChanges();
        }
    }
}

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

app.UseAuthentication();
app.UseAuthorization();

app.MapControllers();

app.Run();
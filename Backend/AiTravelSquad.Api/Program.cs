using AiTravelSquad.Infrastructure.Data;
using AiTravelSquad.Infrastructure.ExternalServices.AiModel;
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

// AI Recommendation API client
builder.Services.AddHttpClient<AiRecommendationClient>(client =>
{
    var aiApiBaseUrl = builder.Configuration["AiApi:BaseUrl"]
        ?? "https://palestine-tourism-recommendation-api.onrender.com";

    client.BaseAddress = new Uri(aiApiBaseUrl);
    client.Timeout = TimeSpan.FromSeconds(60);
});

// CORS
const string FrontendCorsPolicy = "FrontendCorsPolicy";

builder.Services.AddCors(options =>
{
    options.AddPolicy(FrontendCorsPolicy, policy =>
    {
        policy
            .WithOrigins(
                "http://localhost:5500",
                "http://127.0.0.1:5500",
                "http://localhost:5501",
                "http://127.0.0.1:5501",
                "http://localhost:3000",
                "http://127.0.0.1:3000",
                "http://localhost:8080",
                "http://127.0.0.1:8080"
            )
            .WithMethods("GET", "POST", "PUT", "DELETE")
            .AllowAnyHeader();
    });
});

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

builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();

// Import the AI team's v3 dataset (Arabic + English) into the Places table
// on startup. Only imports when the Places table is completely empty.
using (var scope = app.Services.CreateScope())
{
    var dbContext = scope.ServiceProvider.GetRequiredService<ApplicationDbContext>();

    var csvPath = Path.Combine(
        app.Environment.ContentRootPath,
        "..", "AiTravelSquad.Infrastructure",
        "Data", "Csv",
        "palestine_tourist_attractions_v3_ar_and_en.csv");

    // TEMPORARY DIAGNOSTIC: confirm exactly which file is being read and
    // whether it actually contains the Arabic columns we expect.
    Console.WriteLine($"[CSV PATH] {Path.GetFullPath(csvPath)}");
    Console.WriteLine($"[CSV EXISTS] {File.Exists(csvPath)}");
    if (File.Exists(csvPath))
    {
        var firstLine = File.ReadLines(csvPath).First();
        Console.WriteLine($"[CSV HEADER] {firstLine}");
    }

    var needsImport = !dbContext.Places.Any();
    if (needsImport && File.Exists(csvPath))
    {
        dbContext.RecommendationResults.RemoveRange(dbContext.RecommendationResults);
        dbContext.RecommendationRequests.RemoveRange(dbContext.RecommendationRequests);
        dbContext.Places.RemoveRange(dbContext.Places);
        dbContext.SaveChanges();

        var places = CsvPlaceImporter.ImportFromCsv(csvPath);

        // TEMPORARY DIAGNOSTIC: confirm the parsed objects actually have
        // PlaceNameAr populated before they even hit the database.
        Console.WriteLine($"[IMPORTED COUNT] {places.Count}");
        Console.WriteLine($"[FIRST PLACE] Name={places.FirstOrDefault()?.PlaceName}, NameAr={places.FirstOrDefault()?.PlaceNameAr}");

        dbContext.Places.AddRange(places);
        dbContext.SaveChanges();
    }
}

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();
app.UseCors(FrontendCorsPolicy);
app.UseAuthentication();
app.UseAuthorization();
app.MapControllers();

app.Run();

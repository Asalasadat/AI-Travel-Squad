using AiTravelSquad.Infrastructure.Data;
using AiTravelSquad.Infrastructure.ExternalServices.AiModel;
using AiTravelSquad.Infrastructure.SeedData.Csv;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.RateLimiting;
using Microsoft.EntityFrameworkCore;
using System.Text.Json.Serialization;
using System.Threading.RateLimiting;

var builder = WebApplication.CreateBuilder(args);

// ============================================================
// DATABASE
// ============================================================

builder.Services.AddDbContext<ApplicationDbContext>(options =>
    options.UseSqlServer(
        builder.Configuration.GetConnectionString("DefaultConnection")));

// ============================================================
// IDENTITY
// ============================================================

builder.Services.AddIdentity<IdentityUser, IdentityRole>()
    .AddEntityFrameworkStores<ApplicationDbContext>()
    .AddDefaultTokenProviders();

// ============================================================
// AI RECOMMENDATION API CLIENT
// ============================================================

builder.Services.AddHttpClient<AiRecommendationClient>(client =>
{
    var aiApiBaseUrl = builder.Configuration["AiApi:BaseUrl"]
        ?? "https://palestine-tourism-recommendation-api.onrender.com";

    client.BaseAddress = new Uri(aiApiBaseUrl);
    client.Timeout = TimeSpan.FromSeconds(60);
});

// ============================================================
// CORS
// ============================================================

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

// ============================================================
// RATE LIMITING
// ============================================================

// Protects the recommendation endpoint from receiving
// an unlimited number of requests from the same IP.
//
// Limit: 10 requests per minute per IP address.
// Extra requests receive HTTP 429 Too Many Requests.

builder.Services.AddRateLimiter(options =>
{
    options.RejectionStatusCode =
        StatusCodes.Status429TooManyRequests;

    options.AddPolicy("recommendations", httpContext =>
        RateLimitPartition.GetFixedWindowLimiter(
            partitionKey:
                httpContext.Connection.RemoteIpAddress?.ToString()
                ?? "unknown",
            factory: _ => new FixedWindowRateLimiterOptions
            {
                PermitLimit = 10,

                Window = TimeSpan.FromMinutes(1),

                QueueProcessingOrder =
                    QueueProcessingOrder.OldestFirst,

                // Do not queue requests after reaching the limit.
                QueueLimit = 0,

                AutoReplenishment = true
            }));
});

// ============================================================
// CONTROLLERS
// ============================================================

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
                            context.ModelState.Keys.Any(
                                k => k.StartsWith("$.")))
                        {
                            return Array.Empty<string>();
                        }

                        return messages;
                    })
                .Where(x => x.Value.Length > 0)
                .ToDictionary(
                    x => x.Key,
                    x => x.Value);

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

// ============================================================
// CSV DATA IMPORT / IMAGE URL UPDATE
// ============================================================

using (var scope = app.Services.CreateScope())
{
    var dbContext =
        scope.ServiceProvider.GetRequiredService<ApplicationDbContext>();

    var csvPath = Path.Combine(
        app.Environment.ContentRootPath,
        "..",
        "AiTravelSquad.Infrastructure",
        "Data",
        "Csv",
        "__palestine_tourist_dat_with_images - __palestine_tourist_dat_with_images.csv.csv");

    Console.WriteLine(
        $"[CSV PATH] {Path.GetFullPath(csvPath)}");

    Console.WriteLine(
        $"[CSV EXISTS] {File.Exists(csvPath)}");

    if (File.Exists(csvPath))
    {
        var firstLine =
            File.ReadLines(csvPath).FirstOrDefault();

        Console.WriteLine(
            $"[CSV HEADER] {firstLine}");

        var csvPlaces =
            CsvPlaceImporter.ImportFromCsv(csvPath);

        Console.WriteLine(
            $"[CSV COUNT] {csvPlaces.Count}");

        // --------------------------------------------------------
        // If Places table is empty:
        // Import the complete dataset.
        // --------------------------------------------------------

        if (!dbContext.Places.Any())
        {
            dbContext.Places.AddRange(csvPlaces);
            dbContext.SaveChanges();

            Console.WriteLine(
                $"[FULL IMPORT] Imported {csvPlaces.Count} places.");
        }
        else
        {
            // ----------------------------------------------------
            // Places already exist:
            // Update ImageUrl and Arabic data.
            // ----------------------------------------------------

            var existingPlaces =
                dbContext.Places.ToList();

            Console.WriteLine(
                $"[DB COUNT] {existingPlaces.Count}");

            // Diagnostic: compare first 5 records
            foreach (var place in existingPlaces.Take(5))
            {
                Console.WriteLine(
                    $"[DB PLACE] Id={place.Id}, " +
                    $"Name={place.PlaceName}, " +
                    $"NameAr={place.PlaceNameAr}");
            }

            foreach (var place in csvPlaces.Take(5))
            {
                Console.WriteLine(
                    $"[CSV PLACE] Id={place.Id}, " +
                    $"Name={place.PlaceName}, " +
                    $"NameAr={place.PlaceNameAr}, " +
                    $"Image={place.ImageUrl}");
            }

            var updatedImages = 0;
            var updatedArabicData = 0;

            foreach (var csvPlace in csvPlaces)
            {
                if (string.IsNullOrWhiteSpace(
                        csvPlace.PlaceName))
                {
                    continue;
                }

                // Match using the English PlaceName because
                // PlaceNameAr may be empty in existing database records.
                var existingPlace =
                    existingPlaces.FirstOrDefault(p =>
                        !string.IsNullOrWhiteSpace(p.PlaceName) &&
                        p.PlaceName.Trim()
                            .Equals(
                                csvPlace.PlaceName.Trim(),
                                StringComparison.OrdinalIgnoreCase));

                if (existingPlace == null)
                {
                    continue;
                }

                // Update Arabic name.
                if (!string.IsNullOrWhiteSpace(
                        csvPlace.PlaceNameAr))
                {
                    existingPlace.PlaceNameAr =
                        csvPlace.PlaceNameAr;

                    updatedArabicData++;
                }

                // Update Arabic description.
                if (!string.IsNullOrWhiteSpace(
                        csvPlace.DescriptionAr))
                {
                    existingPlace.DescriptionAr =
                        csvPlace.DescriptionAr;
                }

                // Update image URL.
                if (!string.IsNullOrWhiteSpace(
                        csvPlace.ImageUrl))
                {
                    existingPlace.ImageUrl =
                        csvPlace.ImageUrl;

                    updatedImages++;
                }
            }

            dbContext.SaveChanges();

            Console.WriteLine(
                $"[ARABIC DATA UPDATE] Updated {updatedArabicData} Arabic names.");

            Console.WriteLine(
                $"[IMAGE UPDATE] Updated {updatedImages} image URLs.");
        }
    }
    else
    {
        Console.WriteLine(
            "[CSV ERROR] Image CSV file was not found.");
    }
}

// ============================================================
// HTTP PIPELINE
// ============================================================

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

app.UseRouting();

app.UseCors(FrontendCorsPolicy);

// Rate limiting middleware
app.UseRateLimiter();

app.UseAuthentication();
app.UseAuthorization();

app.MapControllers();

app.Run();
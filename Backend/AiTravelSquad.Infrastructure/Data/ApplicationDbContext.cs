using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;
using AiTravelSquad.Domain.Entities;

namespace AiTravelSquad.Infrastructure.Data
{
    /// <summary>
    /// The main EF Core database context for the application.
    /// Inherits from IdentityDbContext to get built-in Identity tables
    /// (Users, Roles, Claims, etc.) in addition to our own domain tables.
    /// We use IdentityUser as-is for now (no custom fields yet).
    /// </summary>
    public class ApplicationDbContext : IdentityDbContext<IdentityUser>
    {
        public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options)
            : base(options)
        {
        }

        /// <summary>Tourist places table</summary>
        public DbSet<Place> Places { get; set; }

        /// <summary>Recommendation requests made by users</summary>
        public DbSet<RecommendationRequest> RecommendationRequests { get; set; }

        /// <summary>Results (places) returned for each recommendation request</summary>
        public DbSet<RecommendationResult> RecommendationResults { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            // Required call so Identity tables are configured correctly
            base.OnModelCreating(modelBuilder);

            // Configure the relationship: one RecommendationRequest has many RecommendationResults.
            // If a request is deleted, its results are deleted too (Cascade).
            modelBuilder.Entity<RecommendationResult>()
                .HasOne(r => r.RecommendationRequest)
                .WithMany(req => req.Results)
                .HasForeignKey(r => r.RecommendationRequestId)
                .OnDelete(DeleteBehavior.Cascade);

            // Configure the relationship: one Place can appear in many RecommendationResults.
            // If a place is deleted, we don't want to delete historical results,
            // so we restrict deletion instead of cascading.
            modelBuilder.Entity<RecommendationResult>()
                .HasOne(r => r.Place)
                .WithMany(p => p.RecommendationResults)
                .HasForeignKey(r => r.PlaceId)
                .OnDelete(DeleteBehavior.Restrict);
        }
    }
}

using AiTravelSquad.Domain.Entities;
using AiTravelSquad.Infrastructure.Data;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace AiTravelSquad.Api.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class PlacesController : ControllerBase
    {
        private readonly ApplicationDbContext _context;

        public PlacesController(ApplicationDbContext context)
        {
            _context = context;
        }

        // GET: api/places/{id}
        [HttpGet("{id:int}")]
        public async Task<ActionResult<Place>> GetPlaceById(int id)
        {
            var place = await _context.Places
                .AsNoTracking()
                .FirstOrDefaultAsync(p => p.Id == id);

            if (place == null)
            {
                return NotFound(new
                {
                    status = 404,
                    message = $"Place with ID {id} was not found."
                });
            }

            return Ok(place);
        }  
        [HttpGet("debug/sample")]
public async Task<IActionResult> GetSample()
{
    var sample = await _context.Places
        .Select(p => new { p.Id, p.PlaceName, p.PlaceNameAr })
        .Take(5)
        .ToListAsync();
    return Ok(sample);
}  

[HttpGet("debug/count")]
public async Task<IActionResult> GetCount()
{
    var total = await _context.Places.CountAsync();
    var withArabicName = await _context.Places.CountAsync(p => p.PlaceNameAr != null);
    return Ok(new { total, withArabicName });
}
[HttpDelete("debug/clear-all")]
public async Task<IActionResult> ClearAllPlaces()
{
    await _context.Database.ExecuteSqlRawAsync("DELETE FROM RecommendationResults");
    await _context.Database.ExecuteSqlRawAsync("DELETE FROM RecommendationRequests");
    await _context.Database.ExecuteSqlRawAsync("DELETE FROM Places");
    await _context.Database.ExecuteSqlRawAsync("DBCC CHECKIDENT ('Places', RESEED, 0)");
    return Ok(new { message = "All places cleared." });
}
    }
}
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
    }
}
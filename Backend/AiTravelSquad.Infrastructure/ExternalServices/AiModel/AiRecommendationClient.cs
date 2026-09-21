using System.Net.Http.Json;
using System.Text.Json;

namespace AiTravelSquad.Infrastructure.ExternalServices.AiModel
{
    /// <summary>
    /// Calls the AI team's recommendation API (hosted on Render) to get
    /// real model-based tourist place recommendations.
    /// This is the only place in the backend that talks to the AI service directly.
    /// Field name mapping is handled explicitly via [JsonPropertyName] on the
    /// request/response models, since the AI API doesn't follow a consistent
    /// naming convention (mix of snake_case and PascalCase_with_underscores).
    /// </summary>
    public class AiRecommendationClient
    {
        private readonly HttpClient _httpClient;

        public AiRecommendationClient(HttpClient httpClient)
        {
            _httpClient = httpClient;
        }

        /// <summary>
        /// Sends the user's preferences to POST /recommendations and returns
        /// the ranked list of recommended places from the AI model.
        /// </summary>
        public async Task<List<AiRecommendationItem>> GetRecommendationsAsync(
            AiRecommendationRequest request, CancellationToken cancellationToken = default)
        {
            var response = await _httpClient.PostAsJsonAsync(
                "/recommendations", request, cancellationToken);

            if (!response.IsSuccessStatusCode)
            {
                var errorBody = await response.Content.ReadAsStringAsync(cancellationToken);
                throw new HttpRequestException(
                    $"AI API returned {(int)response.StatusCode}: {errorBody}");
            }

            var result = await response.Content.ReadFromJsonAsync<AiRecommendationResponse>(
                cancellationToken: cancellationToken);

            return result?.Recommendations ?? new List<AiRecommendationItem>();
        }
    }
}

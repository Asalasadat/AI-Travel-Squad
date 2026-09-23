# AI Travel Squad — Backend

Backend service for the **AI Travel Squad** platform, responsible for managing tourism data, processing trip preferences, and providing AI-powered travel recommendations.

## Tech Stack

* **.NET 10 / ASP.NET Core Web API**
* **Entity Framework Core**
* **SQL Server**
* **ASP.NET Core Identity**
* **Swagger / OpenAPI**
* **HttpClient**
* **CsvHelper**
* External **AI Recommendation API**

## Architecture

The backend follows a **Clean Architecture** structure:

* **AiTravelSquad.Api** — Controllers, DTOs, API configuration
* **AiTravelSquad.Domain** — Entities and enums
* **AiTravelSquad.Infrastructure** — Database, migrations, CSV import, and AI integration

## Core Features

* AI-based travel recommendations based on:

  * Cities
  * Trip types
  * Age group
  * Budget
  * Group size
* Arabic and English tourism data support
* Tourism place management
* Recommendation request and result persistence
* CSV-based tourism dataset integration
* SQL Server database with Entity Framework Core
* Standardized API validation and error responses
* Swagger API documentation
* CORS configuration for frontend integration

## API Endpoints

### Recommendations

`POST /api/Recommendations`

Processes travel preferences, communicates with the AI recommendation service, matches results with local tourism data, and returns ranked recommendations.

### Places

`GET /api/Places/{id}`

Returns tourism place details by ID.

## AI Integration

The backend communicates with the external AI recommendation service through a dedicated `AiRecommendationClient`, sending structured trip preferences and receiving ranked recommendations with similarity scores.

## Data & Persistence

Tourism data is stored in SQL Server and can be populated or updated from the project CSV dataset. Recommendation requests and generated results are persisted through Entity Framework Core.

## Development

Run the API from the `AiTravelSquad.Api` project. Swagger is available in the development environment for API testing and documentation.

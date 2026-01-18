# Task 4.0: HTTP Client & Spotify API Repository

**Important:** Read the prd.md and techspec.md files in this folder before starting.

## Overview

Create HTTP client wrapper around URLSession and implement SpotifyAPIRepository to communicate with Spotify Web API. Handle authentication, rate limiting, pagination, error responses, and JSON parsing.

## Requirements

- Task 2.0 completed (protocols and DTOs defined)
- Spotify Web API documentation understanding
- URLSession and Codable knowledge

## Subtasks

- [ ] 4.1 Create HTTPClient wrapper around URLSession
- [ ] 4.2 Create APIError enum with all Spotify error cases
- [ ] 4.3 Implement request builder with headers and auth token
- [ ] 4.4 Implement rate limiting handler (429 responses)
- [ ] 4.5 Implement automatic token refresh on 401
- [ ] 4.6 Implement fetchUserProfile() endpoint
- [ ] 4.7 Implement fetchPlaylists() with pagination
- [ ] 4.8 Implement fetchTracks(for playlistID:) with pagination
- [ ] 4.9 Implement fetchSavedTracks(limit:offset:)
- [ ] 4.10 Implement fetchSavedAlbums(limit:offset:)
- [ ] 4.11 Implement fetchFollowedArtists()
- [ ] 4.12 Create DTO→Domain model mappers
- [ ] 4.13 Write unit tests with mocked URLSession responses
- [ ] 4.14 Test pagination logic with multiple pages
- [ ] 4.15 Test error handling for all HTTP status codes

## Implementation Details

### Spotify Web API Endpoints:
- **Base URL**: `https://api.spotify.com/v1`
- **GET /me** - Current user profile
- **GET /me/playlists** - User playlists (50 per page)
- **GET /playlists/{id}/tracks** - Playlist tracks (100 per page)
- **GET /me/tracks** - Saved tracks (50 per page)
- **GET /me/albums** - Saved albums (50 per page)
- **GET /me/following?type=artist** - Followed artists (50 per page)

### Error Handling Strategy:
- **401 Unauthorized** → Trigger token refresh, retry request
- **429 Too Many Requests** → Read `Retry-After` header, wait, retry with exponential backoff
- **503 Service Unavailable** → Return user-friendly error
- **400/404** → Return domain-specific error

### Pagination Implementation:
Spotify uses `limit` and `offset` parameters. Handle `next` URL in responses for automatic pagination.

Reference: https://developer.spotify.com/documentation/web-api

## Success Criteria

- HTTPClient can make authenticated GET requests
- All Spotify endpoints implemented and tested
- Pagination works correctly for large libraries (100+ items)
- Rate limiting handled with exponential backoff
- 401 responses trigger token refresh automatically
- DTOs parse correctly from JSON responses
- Domain models created from DTOs with all fields mapped
- Unit tests cover success and error cases
- Mock tests don't require actual Spotify API calls
- No API keys or tokens hardcoded in source

## Dependencies

- Task 2.0 (protocols and DTOs defined)

## Relevant Files

- `Core/Networking/HTTPClient.swift`
- `Core/Networking/APIError.swift`
- `Data/Repositories/SpotifyAPIRepository.swift`
- `Data/DTOs/` (all DTO files)
- `Domain/Models/` (mapper extensions)
- `WinampSpotifyPlayerTests/Data/Repositories/SpotifyAPIRepositoryTests.swift`
- `WinampSpotifyPlayerTests/Mocks/MockHTTPClient.swift`

## Task Context

| Property | Value |
|----------|-------|
| Domain | data_layer |
| Type | implementation |
| Scope | networking |
| Complexity | high |
| Dependencies | spotify_web_api |

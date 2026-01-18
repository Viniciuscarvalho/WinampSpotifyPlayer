# Task 9.0: Library Management Use Case

**Important:** Read the prd.md and techspec.md files in this folder before starting.

## Overview

Implement LibraryManagementUseCase to fetch and manage user's Spotify library including playlists, saved tracks, albums, and followed artists. Handle pagination for large libraries and implement caching strategy.

## Requirements

- Task 4.0 completed (SpotifyAPIRepository implemented)
- Understanding of pagination patterns
- Knowledge of caching strategies

## Subtasks

- [ ] 9.1 Create LibraryManagementUseCase class
- [ ] 9.2 Implement fetchUserPlaylists() with pagination
- [ ] 9.3 Implement fetchPlaylistTracks(playlistID:) with pagination
- [ ] 9.4 Implement fetchSavedTracks() with pagination
- [ ] 9.5 Implement fetchSavedAlbums() with pagination
- [ ] 9.6 Implement fetchFollowedArtists()
- [ ] 9.7 Add caching layer with 60-second TTL
- [ ] 9.8 Handle empty library states gracefully
- [ ] 9.9 Transform DTOs to domain models
- [ ] 9.10 Write unit tests for all fetch operations
- [ ] 9.11 Write unit tests for pagination (100+ items)
- [ ] 9.12 Write unit tests for caching behavior
- [ ] 9.13 Test error handling and propagation

## Implementation Details

### Pagination Strategy:
Automatically fetch all pages until no `next` URL exists:
```swift
func fetchUserPlaylists() async throws -> [Playlist] {
    var allPlaylists: [Playlist] = []
    var offset = 0
    let limit = 50

    repeat {
        let page = try await apiRepository.fetchPlaylists(
            limit: limit,
            offset: offset
        )
        allPlaylists.append(contentsOf: page.items)
        offset += limit

        if page.next == nil { break }
    } while true

    return allPlaylists
}
```

### Caching Implementation:
```swift
private struct CacheEntry<T> {
    let data: T
    let timestamp: Date
    let ttl: TimeInterval = 60 // seconds

    var isValid: Bool {
        Date().timeIntervalSince(timestamp) < ttl
    }
}
```

### DTO → Domain Transformation:
Create extensions on DTOs to convert to domain models:
```swift
extension PlaylistDTO {
    func toDomain() -> Playlist {
        Playlist(
            id: id,
            name: name,
            description: description,
            trackCount: tracks.total,
            imageURL: images.first?.url,
            owner: owner.display_name
        )
    }
}
```

## Success Criteria

- Can fetch all user playlists (handles 50+ playlists)
- Can fetch all tracks in a playlist (handles 100+ tracks)
- Can fetch saved tracks, albums, and artists
- Pagination works correctly for large libraries
- Cache returns valid data within 60 seconds
- Cache refreshes after TTL expires
- Empty library returns empty array (not error)
- All DTOs transformed to domain models correctly
- Unit tests cover pagination edge cases
- Tests use mocked repository
- No performance degradation with large libraries (1000+ tracks)

## Dependencies

- Task 4.0 (SpotifyAPIRepository)

## Relevant Files

- `Domain/UseCases/LibraryManagementUseCase.swift`
- `Core/Caching/CacheService.swift`
- `WinampSpotifyPlayerTests/Domain/UseCases/LibraryManagementUseCaseTests.swift`
- `WinampSpotifyPlayerTests/Mocks/MockSpotifyAPIRepository.swift`

## Task Context

| Property | Value |
|----------|-------|
| Domain | domain_layer |
| Type | implementation |
| Scope | library_management |
| Complexity | medium |
| Dependencies | api_repository |

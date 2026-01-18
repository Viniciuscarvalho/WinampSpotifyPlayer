# Task 2.0: Domain Models & Protocol Definitions

**Important:** Read the prd.md and techspec.md files in this folder before starting.

## Overview

Define all domain models, repository protocols, and use case protocols that form the core contracts of the application. This establishes the foundation for Clean Architecture implementation with clear separation of concerns.

## Requirements

- Task 1.0 completed (project structure exists)
- Understanding of Clean Architecture principles
- Familiarity with Swift protocols and structs

## Subtasks

- [ ] 2.1 Create domain models (User, Track, Playlist, Album, Artist, PlaybackState)
- [ ] 2.2 Create RepeatMode enum
- [ ] 2.3 Define SpotifyAuthUseCaseProtocol
- [ ] 2.4 Define PlaybackControlUseCaseProtocol
- [ ] 2.5 Define LibraryManagementUseCaseProtocol
- [ ] 2.6 Define QueueManagementUseCaseProtocol
- [ ] 2.7 Define SpotifyAPIRepositoryProtocol
- [ ] 2.8 Define SpotifyPlaybackRepositoryProtocol
- [ ] 2.9 Define KeychainRepositoryProtocol
- [ ] 2.10 Create DTOs (TrackDTO, PlaylistDTO, AlbumDTO, ArtistDTO, UserDTO, PlaybackStateDTO)
- [ ] 2.11 Add documentation comments to all protocols

## Implementation Details

Reference `techspec.md` section "Core Interfaces" and "Data Models" for complete interface definitions.

### Key Domain Models:
- **User**: id, displayName, email, imageURL
- **Track**: id, uri, name, artistNames, albumName, durationMs, albumArtURL
- **Playlist**: id, name, description, trackCount, imageURL, owner
- **Album**: id, name, artistNames, releaseDate, trackCount, imageURL
- **Artist**: id, name, imageURL, genres
- **PlaybackState**: isPlaying, currentTrack, positionMs, durationMs, volume, shuffleState, repeatMode

### File Organization:
- Domain models → `Domain/Models/`
- DTOs → `Data/DTOs/`
- Use case protocols → `Domain/UseCases/` (as protocol files)
- Repository protocols → `Data/Repositories/` (as protocol files)

## Success Criteria

- All domain models defined as immutable structs
- All protocols defined with clear method signatures using async/await
- DTOs conform to Decodable for JSON parsing
- All types compile without errors
- Documentation comments explain purpose of each protocol/model
- No implementation code yet (only interfaces and models)

## Dependencies

- Task 1.0 (project structure)

## Relevant Files

- `Domain/Models/User.swift`
- `Domain/Models/Track.swift`
- `Domain/Models/Playlist.swift`
- `Domain/Models/Album.swift`
- `Domain/Models/Artist.swift`
- `Domain/Models/PlaybackState.swift`
- `Domain/UseCases/SpotifyAuthUseCaseProtocol.swift`
- `Domain/UseCases/PlaybackControlUseCaseProtocol.swift`
- `Domain/UseCases/LibraryManagementUseCaseProtocol.swift`
- `Domain/UseCases/QueueManagementUseCaseProtocol.swift`
- `Data/Repositories/Protocols/SpotifyAPIRepositoryProtocol.swift`
- `Data/Repositories/Protocols/SpotifyPlaybackRepositoryProtocol.swift`
- `Data/Repositories/Protocols/KeychainRepositoryProtocol.swift`
- `Data/DTOs/TrackDTO.swift`
- `Data/DTOs/PlaylistDTO.swift`
- `Data/DTOs/AlbumDTO.swift`
- `Data/DTOs/UserDTO.swift`
- `Data/DTOs/PlaybackStateDTO.swift`

## Task Context

| Property | Value |
|----------|-------|
| Domain | domain_layer |
| Type | implementation |
| Scope | core_models |
| Complexity | medium |
| Dependencies | none |

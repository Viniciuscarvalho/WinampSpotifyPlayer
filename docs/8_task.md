# Task 8.0: Playback Control Use Case

**Important:** Read the prd.md and techspec.md files in this folder before starting.

## Overview

Implement PlaybackControlUseCase to manage all playback operations (play, pause, skip, seek, volume, shuffle, repeat). Create Combine publishers for playback state that will drive UI updates.

## Requirements

- Task 7.0 completed (SpotifyPlaybackRepository implemented)
- Understanding of Combine framework
- Understanding of use case pattern in Clean Architecture

## Subtasks

- [ ] 8.1 Create PlaybackControlUseCase class
- [ ] 8.2 Implement play(trackURI:) method
- [ ] 8.3 Implement pause() method
- [ ] 8.4 Implement resume() method
- [ ] 8.5 Implement skipToNext() method
- [ ] 8.6 Implement skipToPrevious() method
- [ ] 8.7 Implement seek(to position:) method
- [ ] 8.8 Implement setVolume(_ volume:) with clamping (0-100)
- [ ] 8.9 Implement toggleShuffle() method
- [ ] 8.10 Implement cycleRepeatMode() method (off→context→track→off)
- [ ] 8.11 Create playbackStatePublisher using Combine
- [ ] 8.12 Transform AsyncStream from repository to Combine publisher
- [ ] 8.13 Handle errors and propagate to UI layer
- [ ] 8.14 Write unit tests for all playback commands
- [ ] 8.15 Write unit tests for shuffle/repeat toggling
- [ ] 8.16 Test playback state publisher emissions

## Implementation Details

### Use Case Structure:
```swift
final class PlaybackControlUseCase: PlaybackControlUseCaseProtocol {
    private let playbackRepository: SpotifyPlaybackRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()

    var playbackStatePublisher: AnyPublisher<PlaybackState, Never> {
        // Convert AsyncStream to Combine publisher
    }

    func play(trackURI: String) async throws {
        try await playbackRepository.play(uri: trackURI)
    }

    // ... other methods
}
```

### Volume Clamping:
Ensure volume stays within 0-100 range:
```swift
func setVolume(_ volume: Int) async throws {
    let clampedVolume = max(0, min(100, volume))
    try await playbackRepository.setVolume(percent: clampedVolume)
}
```

### Repeat Mode Cycling:
```swift
func cycleRepeatMode() async throws {
    let currentMode = await getCurrentRepeatMode()
    let nextMode = switch currentMode {
        case .off: .context
        case .context: .track
        case .track: .off
    }
    try await setRepeatMode(nextMode)
}
```

## Success Criteria

- All playback commands execute successfully
- Volume is clamped between 0-100
- Shuffle and repeat modes toggle correctly
- Playback state publisher emits updates on state changes
- Publisher uses weak self to prevent memory leaks
- All commands handle errors gracefully
- Unit tests cover success and error scenarios
- Tests use mocked repository
- No direct UI dependencies (pure business logic)
- Commands execute within <100ms (as per performance requirements)

## Dependencies

- Task 7.0 (SpotifyPlaybackRepository)

## Relevant Files

- `Domain/UseCases/PlaybackControlUseCase.swift`
- `WinampSpotifyPlayerTests/Domain/UseCases/PlaybackControlUseCaseTests.swift`
- `WinampSpotifyPlayerTests/Mocks/MockSpotifyPlaybackRepository.swift`

## Task Context

| Property | Value |
|----------|-------|
| Domain | domain_layer |
| Type | implementation |
| Scope | playback_logic |
| Complexity | medium |
| Dependencies | playback_repository, combine |

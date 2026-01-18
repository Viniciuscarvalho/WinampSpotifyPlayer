# Task 13.0: Main Player Window

**Important:** Read the prd.md and techspec.md files in this folder before starting.

## Overview

Build the main Winamp-styled player window with LED displays, playback controls, progress bar, volume slider, and Now Playing information. Create PlayerViewModel to manage playback state and wire up to PlaybackControlUseCase.

## Requirements

- Task 8.0 completed (PlaybackControlUseCase)
- Task 12.0 completed (UI components)
- SwiftUI and Combine knowledge

## Subtasks

- [ ] 13.1 Create MainPlayerView with Winamp layout
- [ ] 13.2 Add LED time display (position / duration)
- [ ] 13.3 Add track title scrolling display
- [ ] 13.4 Add playback control buttons (play/pause/stop/prev/next)
- [ ] 13.5 Add progress bar with seek functionality
- [ ] 13.6 Add volume slider
- [ ] 13.7 Add shuffle and repeat toggle buttons
- [ ] 13.8 Add album artwork display
- [ ] 13.9 Create PlayerViewModel with @Published state
- [ ] 13.10 Wire up playback controls to use case
- [ ] 13.11 Subscribe to playback state publisher
- [ ] 13.12 Implement seek with 300ms debounce
- [ ] 13.13 Handle loading states
- [ ] 13.14 Handle error states with user-friendly messages
- [ ] 13.15 Add menu button to open playlist window
- [ ] 13.16 Set fixed window size (550x232 @2x)
- [ ] 13.17 Prevent window resizing
- [ ] 13.18 Write unit tests for PlayerViewModel
- [ ] 13.19 Test all state transitions (idle→loading→playing→paused)

## Implementation Details

### PlayerViewModel Structure:
```swift
@MainActor
class PlayerViewModel: ObservableObject {
    @Published var playbackState: PlaybackState?
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let playbackUseCase: PlaybackControlUseCaseProtocol
    private var cancellables = Set<AnyCancellable>()

    init(playbackUseCase: PlaybackControlUseCaseProtocol) {
        self.playbackUseCase = playbackUseCase
        subscribeToPlaybackState()
    }

    func play() async { }
    func pause() async { }
    func seek(to position: TimeInterval) async { }
    // ... other actions
}
```

### Window Configuration:
```swift
.frame(width: 550, height: 232)
.fixedSize()
.windowResizability(.contentSize)
```

### Seek Debouncing:
Prevent API spam during scrubbing:
```swift
@Published var seekPosition: Double = 0
cancellables.insert(
    $seekPosition
        .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
        .sink { [weak self] position in
            Task { await self?.seek(to: position) }
        }
)
```

### Layout:
Match Winamp Classified v5.5 layout exactly:
- Top: Title bar with minimize/close buttons
- Left: Time display (position/duration)
- Center: Track info scroller, album art
- Right: Volume slider, playlist button
- Bottom: Progress bar, control buttons

## Success Criteria

- Window matches Winamp Classified v5.5 layout
- All buttons functional and wired to playback use case
- LED time display updates every second
- Track info scrolls for long titles
- Progress bar updates smoothly during playback
- Seek works via progress bar drag
- Volume slider adjusts playback volume
- Shuffle/repeat buttons toggle states
- Album artwork loads and displays
- Loading states shown during operations
- Errors display user-friendly messages
- Window size fixed to Winamp dimensions
- All ViewModel tests pass
- UI responds within <100ms to user actions

## Dependencies

- Task 8.0 (PlaybackControlUseCase)
- Task 12.0 (UI components)

## Relevant Files

- `Presentation/Views/MainPlayerView.swift`
- `Presentation/ViewModels/PlayerViewModel.swift`
- `WinampSpotifyPlayerTests/Presentation/ViewModels/PlayerViewModelTests.swift`

## Task Context

| Property | Value |
|----------|-------|
| Domain | presentation_layer |
| Type | implementation |
| Scope | main_ui |
| Complexity | high |
| Dependencies | playback_use_case, ui_components, combine |

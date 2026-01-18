# Task 17.0: Menu Bar Integration

**Important:** Read the prd.md and techspec.md files in this folder before starting.

## Overview

Create menu bar item with icon and dropdown showing Now Playing info and mini playback controls. Update menu bar in real-time as playback state changes.

## Requirements

- Task 8.0 completed (PlaybackControlUseCase)
- Task 12.0 completed (UI components)
- Understanding of NSStatusItem and SwiftUI integration

## Subtasks

- [ ] 17.1 Create MenuBarView with NSStatusItem
- [ ] 17.2 Design menu bar icon (both light and dark mode)
- [ ] 17.3 Create popover menu with SwiftUI
- [ ] 17.4 Display Now Playing info (track, artist, album art)
- [ ] 17.5 Add mini playback controls (play/pause, next, previous)
- [ ] 17.6 Add volume control in menu
- [ ] 17.7 Add "Show Main Window" option
- [ ] 17.8 Add "Quit" option
- [ ] 17.9 Subscribe to playback state updates
- [ ] 17.10 Update menu bar icon when playing/paused
- [ ] 17.11 Update Now Playing info in real-time
- [ ] 17.12 Handle clicks on menu items
- [ ] 17.13 Test in both light and dark mode

## Implementation Details

### NSStatusItem Setup:
```swift
class MenuBarController {
    private var statusItem: NSStatusItem?

    func setupMenuBar() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)

        if let button = statusItem?.button {
            button.image = NSImage(named: "MenuBarIcon")
            button.action = #selector(togglePopover)
            button.target = self
        }
    }
}
```

### Menu Structure:
```
┌─────────────────────────────┐
│ 🎵 Now Playing              │
│ Track Name                  │
│ Artist Name                 │
├─────────────────────────────┤
│ ⏮ ⏯ ⏭                       │
│ 🔊 ▓▓▓▓▓▓▓▓░░ 80%          │
├─────────────────────────────┤
│ Show Main Window            │
│ Quit                        │
└─────────────────────────────┘
```

### Icon States:
- **Idle**: Static music note icon
- **Playing**: Animated bars or different icon
- **Paused**: Paused indicator
- Support both light and dark menu bar

### Integration with SwiftUI:
```swift
class MenuBarViewModel: ObservableObject {
    @Published var currentTrack: Track?
    @Published var isPlaying = false
    @Published var volume: Int = 50

    private let playbackUseCase: PlaybackControlUseCaseProtocol

    func togglePlayPause() async { }
    func skipToNext() async { }
    func skipToPrevious() async { }
    func setVolume(_ volume: Int) async { }
}
```

## Success Criteria

- Menu bar icon appears in system menu bar
- Icon adapts to light/dark mode
- Popover shows on click
- Now Playing info displayed correctly
- Album artwork shows in popover
- Mini controls functional (play/pause/next/prev)
- Volume slider works
- Info updates in real-time during playback
- "Show Main Window" brings window to front
- "Quit" closes app gracefully
- No lag when opening popover (<100ms)
- Works on macOS 12.0+ (tested)

## Dependencies

- Task 8.0 (PlaybackControlUseCase)
- Task 12.0 (UI components for mini controls)

## Relevant Files

- `Services/MenuBarController.swift`
- `Presentation/Views/MenuBarView.swift`
- `Presentation/ViewModels/MenuBarViewModel.swift`
- `Resources/Assets.xcassets/MenuBarIcon.imageset/`

## Task Context

| Property | Value |
|----------|-------|
| Domain | macos_integration |
| Type | implementation |
| Scope | menu_bar |
| Complexity | medium |
| Dependencies | nsstatusitem, swiftui |

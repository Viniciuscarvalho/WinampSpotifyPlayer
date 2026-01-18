# Task 19.0: Touch Bar Support

**Important:** Read the prd.md and techspec.md files in this folder before starting.

## Overview

Add Touch Bar playback controls for compatible MacBook models. Display track info, play/pause, next/previous buttons, and volume control in the Touch Bar.

## Requirements

- Task 8.0 completed (PlaybackControlUseCase)
- Understanding of NSTouchBar API
- Access to MacBook with Touch Bar for testing (or simulator)

## Subtasks

- [ ] 19.1 Create TouchBarController class
- [ ] 19.2 Implement makeTouchBar() method
- [ ] 19.3 Add play/pause button to Touch Bar
- [ ] 19.4 Add next/previous buttons
- [ ] 19.5 Add volume slider (optional)
- [ ] 19.6 Add Now Playing info label
- [ ] 19.7 Update Touch Bar on playback state changes
- [ ] 19.8 Update play/pause button icon (play ↔ pause)
- [ ] 19.9 Wire buttons to PlaybackControlUseCase
- [ ] 19.10 Handle Touch Bar customization
- [ ] 19.11 Test on MacBook with Touch Bar
- [ ] 19.12 Ensure graceful degradation on non-Touch Bar Macs

## Implementation Details

### NSTouchBar Setup:
```swift
extension MainPlayerViewController: NSTouchBarDelegate {
    override func makeTouchBar() -> NSTouchBar? {
        let touchBar = NSTouchBar()
        touchBar.delegate = self
        touchBar.customizationIdentifier = .playerTouchBar
        touchBar.defaultItemIdentifiers = [
            .nowPlaying,
            .flexibleSpace,
            .previousTrack,
            .playPause,
            .nextTrack,
            .flexibleSpace,
            .volume
        ]
        touchBar.customizationAllowedItemIdentifiers = touchBar.defaultItemIdentifiers

        return touchBar
    }

    func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItem.Identifier) -> NSTouchBarItem? {
        switch identifier {
        case .playPause:
            let item = NSCustomTouchBarItem(identifier: identifier)
            let button = NSButton(
                image: isPlaying ? NSImage(named: NSImage.touchBarPauseTemplateName)! :
                                   NSImage(named: NSImage.touchBarPlayTemplateName)!,
                target: self,
                action: #selector(togglePlayPause)
            )
            item.view = button
            return item

        // ... other items
        }
    }
}
```

### Touch Bar Item Identifiers:
```swift
extension NSTouchBar.CustomizationIdentifier {
    static let playerTouchBar = NSTouchBar.CustomizationIdentifier("com.yourcompany.winamp-spotify-player.touchbar")
}

extension NSTouchBarItem.Identifier {
    static let nowPlaying = NSTouchBarItem.Identifier("com.yourcompany.winamp-spotify-player.nowplaying")
    static let playPause = NSTouchBarItem.Identifier("com.yourcompany.winamp-spotify-player.playpause")
    static let nextTrack = NSTouchBarItem.Identifier("com.yourcompany.winamp-spotify-player.next")
    static let previousTrack = NSTouchBarItem.Identifier("com.yourcompany.winamp-spotify-player.previous")
    static let volume = NSTouchBarItem.Identifier("com.yourcompany.winamp-spotify-player.volume")
}
```

### Update Touch Bar on State Change:
```swift
func updateTouchBar(with state: PlaybackState) {
    guard let touchBar = self.touchBar,
          let playPauseItem = touchBar.item(forIdentifier: .playPause) as? NSCustomTouchBarItem,
          let button = playPauseItem.view as? NSButton else {
        return
    }

    button.image = state.isPlaying ?
        NSImage(named: NSImage.touchBarPauseTemplateName)! :
        NSImage(named: NSImage.touchBarPlayTemplateName)!

    // Update Now Playing label
    // ...
}
```

Reference: https://developer.apple.com/documentation/appkit/nstouchbar

## Success Criteria

- Touch Bar shows playback controls on compatible Macs
- Play/pause button toggles correctly
- Next/previous buttons skip tracks
- Volume slider adjusts volume (if included)
- Now Playing label shows current track
- Touch Bar updates in real-time with playback state
- Controls functional and responsive (<100ms)
- Gracefully handles non-Touch Bar Macs (no crashes)
- Touch Bar customizable by user
- All buttons wire to correct use case methods

## Dependencies

- Task 8.0 (PlaybackControlUseCase)

## Relevant Files

- `Services/TouchBarController.swift`
- `App/MainPlayerViewController.swift` (Touch Bar delegate)

## Task Context

| Property | Value |
|----------|-------|
| Domain | macos_integration |
| Type | implementation |
| Scope | touch_bar |
| Complexity | low |
| Dependencies | nstouchbar_api |

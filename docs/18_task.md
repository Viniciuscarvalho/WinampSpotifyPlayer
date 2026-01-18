# Task 18.0: Notifications & Now Playing Info

**Important:** Read the prd.md and techspec.md files in this folder before starting.

## Overview

Implement native macOS notifications for track changes and update MPNowPlayingInfoCenter for Control Center and Lock Screen integration.

## Requirements

- Task 8.0 completed (PlaybackControlUseCase)
- Understanding of UNUserNotificationCenter
- Understanding of MPNowPlayingInfoCenter and MPRemoteCommandCenter

## Subtasks

- [ ] 18.1 Create NotificationManager class
- [ ] 18.2 Request notification permission on first launch
- [ ] 18.3 Subscribe to playback state changes
- [ ] 18.4 Post notification on track change
- [ ] 18.5 Include track info (title, artist, album) in notification
- [ ] 18.6 Add album artwork to notification
- [ ] 18.7 Add user preference to enable/disable notifications
- [ ] 18.8 Create NowPlayingInfoUpdater service
- [ ] 18.9 Update MPNowPlayingInfoCenter with track info
- [ ] 18.10 Update playback rate and position
- [ ] 18.11 Set up MPRemoteCommandCenter for Control Center
- [ ] 18.12 Handle play/pause commands from Control Center
- [ ] 18.13 Handle next/previous commands from Control Center
- [ ] 18.14 Test notifications on macOS 12.0+
- [ ] 18.15 Test Control Center integration

## Implementation Details

### NotificationManager:
```swift
class NotificationManager {
    func requestPermission() async -> Bool {
        try? await UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound])
    }

    func postTrackChangeNotification(track: Track) async {
        let content = UNMutableNotificationContent()
        content.title = track.name
        content.subtitle = track.artistNames.joined(separator: ", ")
        content.body = track.albumName

        if let artworkURL = track.albumArtURL {
            let attachment = try? await downloadAttachment(from: artworkURL)
            content.attachments = [attachment].compactMap { $0 }
        }

        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: nil
        )

        try? await UNUserNotificationCenter.current().add(request)
    }
}
```

### MPNowPlayingInfoCenter:
```swift
class NowPlayingInfoUpdater {
    func updateNowPlayingInfo(track: Track, playbackState: PlaybackState) {
        var nowPlayingInfo = [String: Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = track.name
        nowPlayingInfo[MPMediaItemPropertyArtist] = track.artistNames.joined(separator: ", ")
        nowPlayingInfo[MPMediaItemPropertyAlbumTitle] = track.albumName
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = Double(track.durationMs) / 1000.0
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = Double(playbackState.positionMs) / 1000.0
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = playbackState.isPlaying ? 1.0 : 0.0

        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
}
```

### MPRemoteCommandCenter:
```swift
func setupRemoteCommands() {
    let commandCenter = MPRemoteCommandCenter.shared()

    commandCenter.playCommand.addTarget { [weak self] _ in
        Task { await self?.playbackUseCase.resume() }
        return .success
    }

    commandCenter.pauseCommand.addTarget { [weak self] _ in
        Task { await self?.playbackUseCase.pause() }
        return .success
    }

    commandCenter.nextTrackCommand.addTarget { [weak self] _ in
        Task { await self?.playbackUseCase.skipToNext() }
        return .success
    }

    commandCenter.previousTrackCommand.addTarget { [weak self] _ in
        Task { await self?.playbackUseCase.skipToPrevious() }
        return .success
    }
}
```

## Success Criteria

- Notification permission requested on first launch
- Notification shows on every track change
- Notification includes track title, artist, album, and artwork
- User preference to disable notifications works
- MPNowPlayingInfoCenter updated with current track
- Control Center shows correct track info
- Control Center play/pause button works
- Control Center next/previous buttons work
- Lock Screen shows track info and controls
- All commands respond within <100ms
- No crashes from notification errors

## Dependencies

- Task 8.0 (PlaybackControlUseCase)

## Relevant Files

- `Services/NotificationManager.swift`
- `Services/NowPlayingInfoUpdater.swift`
- `Services/RemoteCommandHandler.swift`

## Task Context

| Property | Value |
|----------|-------|
| Domain | macos_integration |
| Type | implementation |
| Scope | notifications |
| Complexity | low |
| Dependencies | user_notifications, media_player_framework |

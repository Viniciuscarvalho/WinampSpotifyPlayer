# Task 7.0: Spotify Web Playback SDK Integration

**Important:** Read the prd.md and techspec.md files in this folder before starting.

## Overview

Integrate Spotify Web Playback SDK using a hidden WKWebView. Implement JavaScript bridge for bidirectional communication between Swift and the SDK. Create state machine for SDK initialization and handle playback state synchronization.

## Requirements

- Task 2.0 completed (protocols defined)
- Task 5.0 completed (OAuth for access token)
- Understanding of WKWebView and JavaScript bridge
- Familiarity with Spotify Web Playback SDK documentation

## Subtasks

- [ ] 7.1 Create player.html file with Spotify SDK initialization
- [ ] 7.2 Create hidden WKWebView component
- [ ] 7.3 Implement WKScriptMessageHandler for JS→Swift messages
- [ ] 7.4 Load player.html in WKWebView
- [ ] 7.5 Implement initializePlayer(accessToken:) method
- [ ] 7.6 Create SDK state machine (notLoaded→loading→ready→error)
- [ ] 7.7 Implement play(uri:) command via JavaScript evaluation
- [ ] 7.8 Implement pause() command
- [ ] 7.9 Implement resume() command
- [ ] 7.10 Implement seek(positionMs:) command
- [ ] 7.11 Implement setVolume(percent:) command
- [ ] 7.12 Subscribe to player_state_changed events
- [ ] 7.13 Create AsyncStream for playback state updates
- [ ] 7.14 Parse PlaybackStateDTO from JavaScript events
- [ ] 7.15 Handle SDK errors and disconnections
- [ ] 7.16 Write unit tests for JavaScript message handling
- [ ] 7.17 Test state synchronization (play/pause/seek)

## Implementation Details

### player.html Structure:
```html
<!DOCTYPE html>
<html>
<head>
    <script src="https://sdk.scdn.co/spotify-player.js"></script>
</head>
<body>
    <script>
        window.onSpotifyWebPlaybackSDKReady = () => {
            // Initialize player
        };

        // Message handlers for Swift commands
        // Post messages back to Swift via webkit.messageHandlers
    </script>
</body>
</html>
```

### JavaScript Bridge Pattern:
Swift → JS: `webView.evaluateJavaScript("playTrack('spotify:track:...')")`
JS → Swift: `webkit.messageHandlers.playbackState.postMessage(state)`

### SDK Initialization:
```javascript
const player = new Spotify.Player({
    name: 'Winamp Spotify Player',
    getOAuthToken: cb => { cb(accessToken); },
    volume: 0.5
});

player.addListener('player_state_changed', state => {
    webkit.messageHandlers.playbackState.postMessage(state);
});

player.connect();
```

### State Machine:
Ensure SDK is in `ready` state before accepting playback commands. Queue commands if SDK is still loading.

Reference: https://developer.spotify.com/documentation/web-playback-sdk

## Success Criteria

- WKWebView loads player.html successfully
- SDK initializes with valid access token
- Can play track URI via JavaScript bridge
- Can pause/resume playback
- Can seek to specific position
- Can adjust volume (0-100)
- Playback state updates received in Swift via message handler
- PlaybackStateDTO parsed correctly from JavaScript events
- State machine prevents commands before SDK is ready
- All unit tests pass
- No memory leaks from WKWebView or message handlers
- SDK reconnects automatically on network disruption

## Dependencies

- Task 2.0 (protocols defined)
- Task 5.0 (OAuth for access token)

## Relevant Files

- `Data/Repositories/SpotifyPlaybackRepository.swift`
- `Resources/SpotifySDK/player.html`
- `Data/DTOs/PlaybackStateDTO.swift`
- `Core/WebView/WebPlaybackBridge.swift`
- `WinampSpotifyPlayerTests/Data/Repositories/SpotifyPlaybackRepositoryTests.swift`

## Task Context

| Property | Value |
|----------|-------|
| Domain | data_layer |
| Type | implementation |
| Scope | playback_integration |
| Complexity | high |
| Dependencies | spotify_web_playback_sdk, wkwebview |

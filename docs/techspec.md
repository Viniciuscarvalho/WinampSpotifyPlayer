# Technical Specification
## Winamp-Inspired Spotify Player for macOS

## Executive Summary

This specification outlines the technical implementation of a native macOS music player that combines Winamp's Classified v5.5 aesthetic with Spotify streaming. The solution employs **Clean Architecture** with clear layer boundaries, **SwiftUI** for native UI, and **Spotify Web Playback SDK** embedded in a WKWebView for audio playback. The architecture separates concerns into Domain, Data, and Presentation layers, with dependency injection via SwiftUI's Environment system. This approach maximizes code testability, maintainability, and aligns with modern Swift development practices while delivering authentic Winamp aesthetics and seamless Spotify integration.

## System Architecture

### Component Overview

The application follows Clean Architecture principles with three primary layers:

**Domain Layer** (Business Logic):
- `SpotifyAuthUseCase`: Handles OAuth flow, token management, and Keychain storage
- `PlaybackControlUseCase`: Manages play, pause, seek, volume, shuffle, repeat operations
- `LibraryManagementUseCase`: Fetches playlists, albums, artists, saved songs
- `QueueManagementUseCase`: Handles queue operations (add, remove, reorder tracks)
- Domain models: `Track`, `Playlist`, `Album`, `Artist`, `User`, `PlaybackState`

**Data Layer** (External Interfaces):
- `SpotifyAPIRepository`: Communicates with Spotify Web API for metadata
- `SpotifyPlaybackRepository`: Interfaces with Spotify Web Playback SDK via WKWebView
- `KeychainRepository`: Securely stores/retrieves OAuth tokens
- `UserDefaultsRepository`: Persists user preferences and app state

**Presentation Layer** (UI):
- `MainPlayerView`: Winamp-styled main window with playback controls
- `PlaylistWindowView`: Separate window for browsing playlists/library
- `MenuBarView`: macOS menu bar integration with mini controls
- `AuthenticationView`: Initial OAuth login screen
- ViewModels: `PlayerViewModel`, `PlaylistViewModel`, `LibraryViewModel`, `AuthViewModel`

**Supporting Systems**:
- `MediaKeyHandler`: Captures macOS media key events (play/pause, next, previous)
- `NotificationManager`: Posts native notifications for track changes
- `TouchBarController`: Provides Touch Bar playback controls
- `NowPlayingInfoCenter`: Updates macOS Now Playing info for Control Center

### Data Flow

1. **Authentication Flow**: User initiates login → `AuthViewModel` calls `SpotifyAuthUseCase` → Opens browser via `ASWebAuthenticationSession` → Receives callback with auth code → Exchanges for tokens → Stores in Keychain via `KeychainRepository`

2. **Playback Flow**: User selects track → `PlayerViewModel` calls `PlaybackControlUseCase` → Communicates with `SpotifyPlaybackRepository` → WKWebView executes JavaScript to control Spotify Web Playback SDK → Playback state updates propagate back through Combine publishers → UI updates reactively

3. **Library Browsing**: User opens playlists → `LibraryViewModel` calls `LibraryManagementUseCase` → Fetches data via `SpotifyAPIRepository` → HTTP requests to Spotify Web API → Parses JSON responses → Transforms to domain models → Publishes to UI

## Implementation Design

### Core Interfaces

```swift
// MARK: - Domain Layer Use Cases

protocol SpotifyAuthUseCaseProtocol {
  func authenticate() async throws -> User
  func refreshAccessToken() async throws
  func logout() async throws
  var isAuthenticated: Bool { get }
}

protocol PlaybackControlUseCaseProtocol {
  func play(trackURI: String) async throws
  func pause() async throws
  func resume() async throws
  func skipToNext() async throws
  func skipToPrevious() async throws
  func seek(to position: TimeInterval) async throws
  func setVolume(_ volume: Int) async throws
  func toggleShuffle() async throws
  func cycleRepeatMode() async throws
  var playbackStatePublisher: AnyPublisher<PlaybackState, Never> { get }
}

protocol LibraryManagementUseCaseProtocol {
  func fetchUserPlaylists() async throws -> [Playlist]
  func fetchPlaylistTracks(playlistID: String) async throws -> [Track]
  func fetchSavedTracks() async throws -> [Track]
  func fetchSavedAlbums() async throws -> [Album]
  func fetchFollowedArtists() async throws -> [Artist]
}

protocol QueueManagementUseCaseProtocol {
  func addToQueue(trackURI: String) async throws
  func removeFromQueue(at index: Int) async throws
  func reorderQueue(from: Int, to: Int) async throws
  func getCurrentQueue() async throws -> [Track]
}

// MARK: - Data Layer Repositories

protocol SpotifyAPIRepositoryProtocol {
  func fetchPlaylists() async throws -> [PlaylistDTO]
  func fetchTracks(for playlistID: String) async throws -> [TrackDTO]
  func fetchUserProfile() async throws -> UserDTO
  func fetchSavedTracks(limit: Int, offset: Int) async throws -> [TrackDTO]
}

protocol SpotifyPlaybackRepositoryProtocol {
  func initializePlayer(accessToken: String) async throws
  func play(uri: String) async throws
  func pause() async throws
  func resume() async throws
  func seek(positionMs: Int) async throws
  func setVolume(percent: Int) async throws
  var playbackStateStream: AsyncStream<PlaybackStateDTO> { get }
}

protocol KeychainRepositoryProtocol {
  func save(accessToken: String) throws
  func save(refreshToken: String) throws
  func getAccessToken() throws -> String?
  func getRefreshToken() throws -> String?
  func deleteTokens() throws
}
```

### Data Models

```swift
// MARK: - Domain Models

struct User {
  let id: String
  let displayName: String
  let email: String?
  let imageURL: URL?
}

struct Track {
  let id: String
  let uri: String
  let name: String
  let artistNames: [String]
  let albumName: String
  let durationMs: Int
  let albumArtURL: URL?
}

struct Playlist {
  let id: String
  let name: String
  let description: String?
  let trackCount: Int
  let imageURL: URL?
  let owner: String
}

struct Album {
  let id: String
  let name: String
  let artistNames: [String]
  let releaseDate: String
  let trackCount: Int
  let imageURL: URL?
}

struct PlaybackState {
  let isPlaying: Bool
  let currentTrack: Track?
  let positionMs: Int
  let durationMs: Int
  let volume: Int // 0-100
  let shuffleState: Bool
  let repeatMode: RepeatMode
}

enum RepeatMode {
  case off
  case track
  case context // playlist/album
}

// MARK: - Data Transfer Objects (DTOs)

struct TrackDTO: Decodable {
  let id: String
  let uri: String
  let name: String
  let artists: [ArtistDTO]
  let album: AlbumDTO
  let duration_ms: Int
}

struct PlaylistDTO: Decodable {
  let id: String
  let name: String
  let description: String?
  let tracks: TracksContainer
  let images: [ImageDTO]
  let owner: OwnerDTO
}

struct PlaybackStateDTO {
  let paused: Bool
  let position: Int
  let duration: Int
  let track_window: TrackWindow

  struct TrackWindow {
    let current_track: TrackDTO
  }
}
```

### Integration Points

#### Spotify Web API
- **Base URL**: `https://api.spotify.com/v1`
- **Authentication**: Bearer token in `Authorization` header
- **Key Endpoints**:
  - `GET /me` - Current user profile
  - `GET /me/playlists` - User playlists (paginated, 50 per page)
  - `GET /playlists/{id}/tracks` - Playlist tracks (paginated)
  - `GET /me/tracks` - Saved tracks (paginated)
  - `GET /me/albums` - Saved albums (paginated)
  - `GET /me/following?type=artist` - Followed artists
- **Rate Limiting**: Implement exponential backoff with 429 response handling
- **Error Handling**:
  - 401 Unauthorized → Trigger token refresh
  - 429 Too Many Requests → Retry after delay from `Retry-After` header
  - 503 Service Unavailable → Show user-friendly error message

#### Spotify OAuth 2.0
- **Authorization URL**: `https://accounts.spotify.com/authorize`
- **Token URL**: `https://accounts.spotify.com/api/token`
- **Scopes Required**:
  - `user-read-email`
  - `user-read-private`
  - `user-library-read`
  - `user-read-playback-state`
  - `user-modify-playback-state`
  - `streaming`
  - `playlist-read-private`
  - `playlist-read-collaborative`
- **Implementation**: Use `ASWebAuthenticationSession` for browser-based OAuth
- **Callback URL**: Custom URL scheme `winampspotify://callback`

#### Spotify Web Playback SDK
- **Integration Method**: Hidden `WKWebView` with SDK loaded
- **JavaScript Bridge**: Use `WKScriptMessageHandler` for Swift ↔ JS communication
- **Initialization**:
  ```javascript
  window.onSpotifyWebPlaybackSDKReady = () => {
    const player = new Spotify.Player({
      name: 'Winamp Spotify Player',
      getOAuthToken: cb => { cb(accessToken); },
      volume: 0.5
    });
    player.connect();
  };
  ```
- **State Sync**: Subscribe to `player_state_changed` events, post to Swift via message handler
- **Commands**: Execute player methods (`play`, `pause`, `seek`) from Swift by evaluating JavaScript

#### macOS Keychain
- **Service Name**: `com.yourcompany.winamp-spotify-player`
- **Items**:
  - `spotify_access_token` (kSecClassGenericPassword)
  - `spotify_refresh_token` (kSecClassGenericPassword)
- **Access Control**: `kSecAttrAccessibleAfterFirstUnlock`

## Testing Strategy

### Unit Tests

**SpotifyAuthUseCase Tests**:
- Mock `SpotifyAPIRepository` and `KeychainRepository`
- Test successful authentication flow
- Test token refresh when expired
- Test logout clearing tokens
- Test handling of invalid credentials (401 errors)

**PlaybackControlUseCase Tests**:
- Mock `SpotifyPlaybackRepository`
- Test play command with valid track URI
- Test pause/resume state transitions
- Test seek within valid range (0 to duration)
- Test volume clamping (0-100)
- Test shuffle/repeat mode toggling

**LibraryManagementUseCase Tests**:
- Mock `SpotifyAPIRepository`
- Test playlist fetching and DTO → Domain model transformation
- Test pagination handling for large libraries
- Test empty state handling (no playlists)
- Test network error propagation

**QueueManagementUseCase Tests**:
- Mock `SpotifyPlaybackRepository`
- Test adding tracks to queue
- Test removing tracks by index
- Test reordering with drag-drop indices
- Test edge cases (empty queue, invalid indices)

**Repository Tests**:
- `SpotifyAPIRepository`: Test HTTP client integration, JSON parsing, error mapping
- `KeychainRepository`: Test saving, retrieving, deleting tokens (use test Keychain)
- `SpotifyPlaybackRepository`: Test JavaScript message handling, state parsing

**ViewModel Tests**:
- Test state updates on use case success/failure
- Test Combine publisher chains
- Test debouncing for seek slider (avoid spamming API)
- Test loading states and error handling

### Mocking Strategy

Use protocol-based dependency injection for easy mocking:
```swift
final class MockSpotifyAPIRepository: SpotifyAPIRepositoryProtocol {
  var playlistsToReturn: [PlaylistDTO] = []
  var shouldThrowError = false

  func fetchPlaylists() async throws -> [PlaylistDTO] {
    if shouldThrowError { throw MockError.networkError }
    return playlistsToReturn
  }
}
```

## Development Sequencing

### Build Order

**Phase 1: Foundation (Week 1)**
1. **Project Setup**: Create Xcode project, configure Swift Package Manager dependencies
2. **Domain Models**: Define all domain entities (`Track`, `Playlist`, `User`, etc.)
3. **Repository Protocols**: Define all protocol interfaces
4. **Keychain Integration**: Implement `KeychainRepository` with unit tests

**Phase 2: Authentication (Week 2)**
1. **Spotify OAuth**: Implement `SpotifyAuthUseCase` with `ASWebAuthenticationSession`
2. **Token Management**: Implement refresh logic and Keychain storage
3. **Auth UI**: Build `AuthenticationView` with SwiftUI
4. **Auth Testing**: Unit tests for auth flow

**Phase 3: Spotify API Integration (Week 3)**
1. **HTTP Client**: Set up URLSession-based API client with error handling
2. **API Repository**: Implement `SpotifyAPIRepository` for all endpoints
3. **Library Use Cases**: Implement `LibraryManagementUseCase`
4. **API Testing**: Unit tests with mocked responses

**Phase 4: Playback Integration (Week 4)**
1. **WKWebView Setup**: Create hidden web view, load Spotify SDK
2. **JS Bridge**: Implement `WKScriptMessageHandler` for bidirectional communication
3. **Playback Repository**: Implement `SpotifyPlaybackRepository`
4. **Playback Use Case**: Implement `PlaybackControlUseCase`
5. **Playback Testing**: Unit tests with mocked JS responses

**Phase 5: Core UI (Week 5-6)**
1. **Winamp Asset Creation**: Design/extract @2x/@3x assets from Classified v5.5 skin
2. **Main Player View**: Build Winamp-styled main window with LED displays, buttons
3. **Player ViewModel**: Implement reactive state management with Combine
4. **Playback Controls**: Wire up play/pause/skip/seek/volume controls
5. **Now Playing Display**: Implement track info and album art display

**Phase 6: Library & Playlists (Week 7)**
1. **Playlist Window**: Build browsable playlist/library view
2. **Library ViewModel**: Implement data fetching and state management
3. **Track List View**: Winamp-styled track listing with selection
4. **Double-Click Play**: Wire up track playback from list

**Phase 7: Queue Management (Week 8)**
1. **Queue View**: Display upcoming tracks in playlist window
2. **Queue Use Case**: Implement add/remove/reorder operations
3. **Drag-and-Drop**: Implement reordering UI with SwiftUI drag gestures

**Phase 8: macOS Integration (Week 9)**
1. **Media Keys**: Implement `MediaKeyHandler` using `CGEventTap`
2. **Menu Bar**: Build `MenuBarView` with `NSStatusItem`
3. **Notifications**: Implement track change notifications with `UNUserNotificationCenter`
4. **Touch Bar**: Add playback controls using `NSTouchBar` API
5. **Now Playing Info**: Update `MPNowPlayingInfoCenter` for Control Center

**Phase 9: Polish & Testing (Week 10)**
1. **Error Handling**: Implement user-facing error messages and retry logic
2. **Loading States**: Add skeleton screens and progress indicators
3. **Accessibility**: VoiceOver labels, keyboard navigation, focus management
4. **Performance**: Profile and optimize (target <100ms UI response, <2s playback start)
5. **End-to-End Testing**: Manual QA of all user flows

### Technical Dependencies

**External Services**:
- Spotify Developer Account with registered OAuth app (required before Phase 2)
- Spotify Premium account (recommended for testing, required for Web Playback SDK)

**Development Tools**:
- Xcode 15.0+ (for macOS 12.0+ deployment target)
- Swift 5.9+ (for modern concurrency features)

**Third-Party Libraries** (via Swift Package Manager):
- None required for MVP (using native frameworks only)
- Optional: `KeychainAccess` for simplified Keychain operations (can implement manually)

## Technical Considerations

### Key Decisions

**Decision 1: Clean Architecture with SwiftUI Environment DI**
- **Rationale**: Clean Architecture provides clear separation of concerns, making code testable and maintainable. Layer boundaries prevent tight coupling between UI, business logic, and data sources. SwiftUI Environment offers lightweight DI without heavy frameworks.
- **Trade-offs**: More boilerplate upfront vs. long-term maintainability. Extra abstraction layers vs. ease of testing.
- **Rejected Alternative**: Simple MVC - rejected because mixing concerns makes testing difficult and code harder to navigate in a complex app.

**Decision 2: WKWebView + Spotify Web Playback SDK**
- **Rationale**: Official Spotify SDK with full support. No need to handle audio streaming manually. Simplifies implementation significantly.
- **Trade-offs**: Requires hidden web view (slight memory overhead ~30MB). JavaScript bridge adds complexity but is manageable.
- **Rejected Alternatives**:
  - Native AVPlayer with direct streaming - rejected because Spotify doesn't provide direct audio stream URLs, requires reverse engineering
  - libspotify or community SDKs - rejected because deprecated/unsupported

**Decision 3: Combine for Reactive State Management**
- **Rationale**: Native Swift framework, integrates seamlessly with SwiftUI. Perfect for propagating playback state changes from SDK → ViewModel → View.
- **Trade-offs**: Learning curve for Combine operators. Memory management requires careful `[weak self]` in closures.
- **Rejected Alternative**: Async/await only - rejected because Combine's publishers are better suited for continuous state streams (playback position updates every second).

**Decision 4: Winamp UI with Fixed Assets, No Skinning**
- **Rationale**: Simplifies V1 implementation. Focus on authentic recreation of one skin rather than building entire skinning engine.
- **Trade-offs**: No customization vs. simpler codebase. Users get consistent experience.
- **Rejected Alternative**: Full .wsz skin loading - rejected as over-engineering for learning/portfolio project.

### Known Risks

**Risk 1: Spotify API Rate Limiting**
- **Challenge**: Exceeding API rate limits during library syncing or rapid user actions
- **Mitigation**: Implement request debouncing (300ms delay on seek slider), caching for playlist/library data (60-second TTL), exponential backoff on 429 responses

**Risk 2: WKWebView Playback SDK Initialization Timing**
- **Challenge**: Race conditions between SDK loading and playback commands
- **Mitigation**: Use async/await to ensure SDK is ready before accepting commands. Add initialization state machine: `notLoaded` → `loading` → `ready` → `error`

**Risk 3: macOS Media Key Conflicts**
- **Challenge**: Other apps (Apple Music, Spotify app) competing for media key events
- **Mitigation**: Use `CGEventTap` with proper `NSEvent` handling. Add user preference to enable/disable media key capture. Document known conflicts.

**Risk 4: Memory Leaks from Combine Subscriptions**
- **Challenge**: Retain cycles in Combine chains and closures
- **Mitigation**: Use `[weak self]` in all closures. Use `.store(in: &cancellables)` consistently. Profile with Instruments to catch leaks early.

**Risk 5: Winamp UI Complexity on Retina Displays**
- **Challenge**: Pixel-perfect recreation requires careful asset scaling and positioning
- **Mitigation**: Export assets at @1x, @2x, @3x. Use vector PDFs where possible. Test on multiple display resolutions early.

### Special Requirements

**Performance Targets**:
- **UI Responsiveness**: All button taps must respond within 100ms (haptic feedback or visual state change)
- **Playback Latency**: Track must start playing within 2 seconds of user action
- **Memory Usage**: App should stay under 200MB RAM during normal use (main window + playlist window open)
- **Search Performance**: Library filtering should complete within 100ms for up to 10,000 tracks

**Security Considerations**:
- **Token Storage**: Access/refresh tokens stored in macOS Keychain with `kSecAttrAccessibleAfterFirstUnlock`
- **HTTPS Only**: All network communication must use TLS 1.2+
- **No Logging of Tokens**: Never log access tokens or refresh tokens to console/files
- **Code Signing**: App must be signed with Developer ID for distribution outside Mac App Store

**Accessibility Requirements**:
- **VoiceOver**: All buttons labeled with `accessibilityLabel`, track info announced
- **Keyboard Navigation**: Full keyboard control - Space (play/pause), Cmd+Up/Down (volume), Cmd+Left/Right (previous/next)
- **Reduced Motion**: Respect `UIAccessibility.isReduceMotionEnabled` for animations
- **High Contrast**: Ensure Winamp UI maintains 4.5:1 contrast ratio for text

**Monitoring Needs**:
- **Crash Reporting**: Integrate basic crash logging (consider OSLog for development, optional Sentry for production)
- **Analytics**: Track key events (auth success/failure, playback errors, API failures) for debugging
- **Performance Metrics**: Log playback start time, API response times to identify bottlenecks

### Relevant Files

**Project Structure** (to be created):
```
WinampSpotifyPlayer/
├── WinampSpotifyPlayer.xcodeproj
├── WinampSpotifyPlayer/
│   ├── App/
│   │   ├── WinampSpotifyPlayerApp.swift
│   │   └── AppDelegate.swift
│   ├── Domain/
│   │   ├── Models/
│   │   │   ├── User.swift
│   │   │   ├── Track.swift
│   │   │   ├── Playlist.swift
│   │   │   ├── Album.swift
│   │   │   └── PlaybackState.swift
│   │   └── UseCases/
│   │       ├── SpotifyAuthUseCase.swift
│   │       ├── PlaybackControlUseCase.swift
│   │       ├── LibraryManagementUseCase.swift
│   │       └── QueueManagementUseCase.swift
│   ├── Data/
│   │   ├── Repositories/
│   │   │   ├── SpotifyAPIRepository.swift
│   │   │   ├── SpotifyPlaybackRepository.swift
│   │   │   ├── KeychainRepository.swift
│   │   │   └── UserDefaultsRepository.swift
│   │   └── DTOs/
│   │       ├── TrackDTO.swift
│   │       ├── PlaylistDTO.swift
│   │       └── PlaybackStateDTO.swift
│   ├── Presentation/
│   │   ├── Views/
│   │   │   ├── AuthenticationView.swift
│   │   │   ├── MainPlayerView.swift
│   │   │   ├── PlaylistWindowView.swift
│   │   │   └── MenuBarView.swift
│   │   ├── ViewModels/
│   │   │   ├── AuthViewModel.swift
│   │   │   ├── PlayerViewModel.swift
│   │   │   ├── LibraryViewModel.swift
│   │   │   └── QueueViewModel.swift
│   │   └── Components/
│   │       ├── WinampButton.swift
│   │       ├── LEDDisplay.swift
│   │       ├── ProgressBar.swift
│   │       └── VolumeSlider.swift
│   ├── Core/
│   │   ├── Networking/
│   │   │   ├── HTTPClient.swift
│   │   │   └── APIError.swift
│   │   ├── Keychain/
│   │   │   └── KeychainService.swift
│   │   └── Extensions/
│   │       ├── Color+Hex.swift
│   │       └── View+Extensions.swift
│   ├── Services/
│   │   ├── MediaKeyHandler.swift
│   │   ├── NotificationManager.swift
│   │   ├── TouchBarController.swift
│   │   └── NowPlayingInfoUpdater.swift
│   └── Resources/
│       ├── Assets.xcassets/
│       │   └── WinampUI/ (all UI assets @2x, @3x)
│       ├── SpotifySDK/
│       │   └── player.html (Web Playback SDK loader)
│       └── Info.plist
└── WinampSpotifyPlayerTests/
    ├── Domain/
    │   └── UseCases/
    ├── Data/
    │   └── Repositories/
    ├── Presentation/
    │   └── ViewModels/
    └── Mocks/
        ├── MockSpotifyAPIRepository.swift
        ├── MockSpotifyPlaybackRepository.swift
        └── MockKeychainRepository.swift
```

**Reference Documentation**:
- Spotify Web API: https://developer.spotify.com/documentation/web-api
- Spotify Web Playback SDK: https://developer.spotify.com/documentation/web-playback-sdk
- ASWebAuthenticationSession: https://developer.apple.com/documentation/authenticationservices/aswebauthenticationsession
- WKWebView + JS Bridge: https://developer.apple.com/documentation/webkit/wkscriptmessagehandler
- CGEventTap (Media Keys): https://developer.apple.com/documentation/coregraphics/cgeventtap

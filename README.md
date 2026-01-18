# Winamp Spotify Player for macOS

A native macOS music player that combines the nostalgic aesthetic of Winamp (Classified v5.5 skin) with modern Spotify streaming capabilities.

## Project Status

### ✅ Completed Tasks

#### Task 1: Project Initialization & Architecture Setup
- [x] Created macOS Xcode project with SwiftUI
- [x] Set deployment target to macOS 12.0 (Monterey)
- [x] Configured custom URL scheme `winampspotify://callback` for OAuth
- [x] Established Clean Architecture folder structure (Domain/Data/Presentation/Core/Services)
- [x] Set up unit testing target
- [x] Created .gitignore and initialized Git repository
- [x] Project builds successfully

#### Task 2: Domain Models & Protocol Definitions
- [x] Created all domain models: User, Track, Playlist, Album, Artist, PlaybackState
- [x] Defined RepeatMode enum
- [x] Defined use case protocols:
  - SpotifyAuthUseCaseProtocol
  - PlaybackControlUseCaseProtocol
  - LibraryManagementUseCaseProtocol
  - QueueManagementUseCaseProtocol
- [x] Defined repository protocols:
  - SpotifyAPIRepositoryProtocol
  - SpotifyPlaybackRepositoryProtocol
  - KeychainRepositoryProtocol
- [x] Created DTOs for Spotify API responses
- [x] All code verified to compile successfully via Swift Package Manager

### 📋 Architecture

The project follows Clean Architecture principles with three primary layers:

**Domain Layer** (`Domain/`):
- Models: Core business entities (Track, Playlist, User, etc.)
- UseCases: Business logic protocols defining application operations

**Data Layer** (`Data/`):
- Repositories/Protocols: Interfaces for external data sources
- DTOs: Data Transfer Objects for API response parsing

**Presentation Layer** (`Presentation/`):
- Views: SwiftUI-based UI components
- ViewModels: Presentation logic and state management
- Components: Reusable Winamp-styled UI elements

**Supporting Systems**:
- Core: Networking, Keychain, Extensions
- Services: Media keys, notifications, Touch Bar support

### 🎯 Next Steps

**Task 3: Keychain Integration**
- Implement KeychainRepository for secure token storage
- Create unit tests for Keychain operations

**Task 4: HTTP Client & Spotify API Repository**
- Implement HTTP client with error handling
- Create SpotifyAPIRepository implementation
- Add unit tests with mocked responses

**Task 5: Spotify OAuth Implementation**
- Implement SpotifyAuthUseCase with ASWebAuthenticationSession
- Handle token exchange and refresh logic
- Integrate with KeychainRepository

See `docs/tasks.md` for the complete 23-task implementation plan.

### 📚 Documentation

All planning documents are located in the `docs/` directory:
- `docs/prd.md` - Product Requirements Document
- `docs/techspec.md` - Technical Specification
- `docs/tasks.md` - Master task list
- `docs/1_task.md` through `docs/23_task.md` - Individual task specifications

### 🛠 Technology Stack

- **Language**: Swift 5.9+
- **UI Framework**: SwiftUI
- **Reactive Framework**: Combine
- **Architecture**: Clean Architecture
- **Dependency Injection**: SwiftUI Environment
- **Minimum macOS**: 12.0 (Monterey)

### 🔧 Build Instructions

**Using Swift Package Manager (for verification)**:
```bash
swift build
```

**Using Xcode**:
1. Open `WinampSpotifyPlayer.xcodeproj` in Xcode
2. Note: New Swift files need to be manually added to the Xcode project via:
   - Right-click on WinampSpotifyPlayer group → "Add Files to WinampSpotifyPlayer..."
   - Select all Swift files in Domain/, Data/Repositories/Protocols/, and Data/DTOs/
3. Build the project (⌘+B)

### ⚠️ Important Notes

- **Xcode Project Files**: The Swift files created in Tasks 1-2 need to be added to the Xcode project manually via Xcode's GUI, as automated project.pbxproj editing is complex and error-prone.
- **Spotify Developer Account**: You'll need to register a Spotify OAuth application before implementing authentication (Task 5).
- **Spotify Premium**: Required for Web Playback SDK functionality.

### 📝 Git History

The project maintains a clean commit history with detailed commit messages:
- Initial project setup and architecture
- Domain models and protocol definitions
- Documentation organization

Each task completion is committed separately with comprehensive descriptions.

## License

This is a portfolio/learning project. See individual dependencies for their licenses.

## Contributing

This is a personal learning project, but feedback and suggestions are welcome via issues.

---

Built with Swift and SwiftUI for macOS 12.0+

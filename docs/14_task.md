# Task 14.0: Playlist & Library Window

**Important:** Read the prd.md and techspec.md files in this folder before starting.

## Overview

Build the playlist and library browsing window with Winamp-styled track listing. Create LibraryViewModel to manage library data fetching and implement double-click to play functionality.

## Requirements

- Task 9.0 completed (LibraryManagementUseCase)
- Task 8.0 completed (PlaybackControlUseCase for playing tracks)
- Task 12.0 completed (UI components)

## Subtasks

- [ ] 14.1 Create PlaylistWindowView with Winamp styling
- [ ] 14.2 Add sidebar for library navigation (Playlists/Albums/Artists/Saved)
- [ ] 14.3 Create track list view with columns (#, Title, Artist, Album, Duration)
- [ ] 14.4 Add Winamp-styled scrollbar
- [ ] 14.5 Implement row selection (single and multiple)
- [ ] 14.6 Implement double-click to play track
- [ ] 14.7 Implement right-click context menu (Play, Add to Queue)
- [ ] 14.8 Create LibraryViewModel with @Published state
- [ ] 14.9 Fetch playlists on view appear
- [ ] 14.10 Fetch playlist tracks when playlist selected
- [ ] 14.11 Display album artwork thumbnails
- [ ] 14.12 Add search/filter functionality
- [ ] 14.13 Handle loading states with skeleton screens
- [ ] 14.14 Handle empty states (no playlists)
- [ ] 14.15 Handle errors gracefully
- [ ] 14.16 Set window size (400x600 minimum, resizable)
- [ ] 14.17 Write unit tests for LibraryViewModel
- [ ] 14.18 Test selection and playback logic

## Implementation Details

### LibraryViewModel Structure:
```swift
@MainActor
class LibraryViewModel: ObservableObject {
    @Published var playlists: [Playlist] = []
    @Published var selectedPlaylist: Playlist?
    @Published var tracks: [Track] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let libraryUseCase: LibraryManagementUseCaseProtocol
    private let playbackUseCase: PlaybackControlUseCaseProtocol

    func fetchPlaylists() async { }
    func selectPlaylist(_ playlist: Playlist) async { }
    func playTrack(_ track: Track) async { }
    func addToQueue(_ track: Track) async { }
}
```

### Track List Layout:
```
┌─────────────────────────────────────────┐
│ # │ Title     │ Artist   │ Album   │ ⏱  │
├─────────────────────────────────────────┤
│ 1 │ Song Name │ Artist   │ Album   │3:45│
│ 2 │ ...       │ ...      │ ...     │... │
└─────────────────────────────────────────┘
```

### Double-Click Handler:
```swift
.onTapGesture(count: 2) {
    Task {
        await viewModel.playTrack(track)
    }
}
```

### Search/Filter:
```swift
var filteredTracks: [Track] {
    guard !searchText.isEmpty else { return tracks }
    return tracks.filter { track in
        track.name.localizedCaseInsensitiveContains(searchText) ||
        track.artistNames.contains { $0.localizedCaseInsensitiveContains(searchText) }
    }
}
```

## Success Criteria

- Window displays all user playlists
- Sidebar navigation works (Playlists/Albums/Artists)
- Track list shows all tracks with proper columns
- Double-click plays track immediately
- Right-click shows context menu
- Selection highlighting matches Winamp style
- Loading states show skeleton screens
- Empty states show helpful messages
- Search filters tracks in real-time
- Album artwork thumbnails load and display
- Window resizable but maintains minimum size
- All ViewModel tests pass
- No UI lag when scrolling 1000+ tracks

## Dependencies

- Task 9.0 (LibraryManagementUseCase)
- Task 8.0 (PlaybackControlUseCase)
- Task 12.0 (UI components)

## Relevant Files

- `Presentation/Views/PlaylistWindowView.swift`
- `Presentation/Views/TrackListView.swift`
- `Presentation/ViewModels/LibraryViewModel.swift`
- `WinampSpotifyPlayerTests/Presentation/ViewModels/LibraryViewModelTests.swift`

## Task Context

| Property | Value |
|----------|-------|
| Domain | presentation_layer |
| Type | implementation |
| Scope | library_ui |
| Complexity | high |
| Dependencies | library_use_case, playback_use_case, ui_components |

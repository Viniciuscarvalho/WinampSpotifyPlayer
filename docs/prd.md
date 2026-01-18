# Product Requirements Document (PRD)
## Winamp-Inspired Spotify Player for macOS

## Overview

This project aims to create a native macOS music player application that combines the nostalgic aesthetic of Winamp (specifically the Classified v5.5 skin) with the modern streaming capabilities of Spotify. The application serves as both a portfolio/learning project and a functional music player for users who appreciate retro software design while wanting seamless access to their Spotify library.

The player will recreate the iconic Winamp interface with its distinctive visual elements (LED displays, equalizer bars, control buttons) while integrating deeply with macOS system features and the Spotify Web API. This bridges the gap between 90s/2000s media player nostalgia and contemporary music streaming.

## Objectives

- **Functional MVP**: Deliver a fully working Spotify player with core playback, playlist, and library management features
- **Visual Fidelity**: Achieve high-fidelity recreation of the Winamp Classified v5.5 skin aesthetic adapted for Retina displays
- **macOS Integration**: Seamlessly integrate with macOS features (menu bar, notifications, media keys, Touch Bar)
- **Portfolio Showcase**: Demonstrate proficiency in native macOS development, API integration, and complex UI implementation
- **User Experience**: Provide smooth, responsive playback controls and navigation comparable to the official Spotify app

## User Stories

### Primary User Persona: Nostalgic Music Enthusiast
A developer or creative professional who grew up with Winamp and wants to combine that aesthetic with modern Spotify streaming.

**Core User Stories:**

- As a user, I want to log into my Spotify account securely via OAuth so that I can access my playlists and saved music
- As a user, I want to see my Spotify playlists in a Winamp-styled interface so that I can experience nostalgia while streaming music
- As a user, I want to control playback (play, pause, skip, volume) using familiar Winamp-style buttons so that the interface feels authentic
- As a user, I want to use my keyboard's media keys to control playback so that I can control music without switching to the app
- As a user, I want to see "Now Playing" notifications so that I know when tracks change even when the app isn't focused
- As a user, I want to access the player from the macOS menu bar so that I can control music without opening the full window
- As a user, I want to manage my playback queue so that I can see what's playing next and reorder upcoming tracks
- As a user, I want to browse my saved albums and artists so that I can explore my library beyond playlists
- As a user, I want to use Touch Bar controls (on compatible MacBooks) so that I have quick access to playback functions

### Secondary User Stories:

- As a user, I want the app to remember my logged-in state so that I don't need to authenticate every time I open it
- As a user, I want to see track progress and remaining time so that I know how long the current song has left
- As a user, I want to adjust volume using a slider so that I can fine-tune audio levels
- As a user, I want to seek within a track so that I can jump to specific parts of songs

## Core Features

### 1. Spotify Authentication
**FR-1.1**: The app shall implement Spotify OAuth 2.0 authentication flow using browser-based login
**FR-1.2**: The app shall securely store access tokens and refresh tokens in macOS Keychain
**FR-1.3**: The app shall automatically refresh expired access tokens without requiring re-authentication
**FR-1.4**: The app shall display user profile information (username, display name) after successful login

### 2. Playback Controls
**FR-2.1**: The app shall provide play, pause, previous track, next track, and stop controls
**FR-2.2**: The app shall display current playback position and total track duration
**FR-2.3**: The app shall allow seeking within the current track via a progress bar
**FR-2.4**: The app shall provide volume control from 0-100% via a slider
**FR-2.5**: The app shall display "Now Playing" information including track title, artist, and album
**FR-2.6**: The app shall support shuffle and repeat modes (off, track, playlist)
**FR-2.7**: The app shall display album artwork for the currently playing track

### 3. Playlist Management
**FR-3.1**: The app shall display all user playlists in a browsable list
**FR-3.2**: The app shall show playlist details (name, description, track count, duration)
**FR-3.3**: The app shall display all tracks within a selected playlist
**FR-3.4**: The app shall allow users to play any track from a playlist
**FR-3.5**: The app shall allow users to play an entire playlist from the beginning

### 4. Library Access
**FR-4.1**: The app shall display user's saved (liked) songs
**FR-4.2**: The app shall display user's saved albums
**FR-4.3**: The app shall display user's followed artists
**FR-4.4**: The app shall allow playing tracks from saved songs, albums, or artist pages

### 5. Queue Management
**FR-5.1**: The app shall display the current playback queue showing upcoming tracks
**FR-5.2**: The app shall allow users to add tracks to the queue
**FR-5.3**: The app shall allow users to remove tracks from the queue
**FR-5.4**: The app shall allow users to reorder tracks in the queue via drag-and-drop

### 6. Winamp-Inspired UI
**FR-6.1**: The app shall replicate the visual design of the Winamp Classified v5.5 skin
**FR-6.2**: The app shall include LED-style displays for track time and song information
**FR-6.3**: The app shall include visual elements mimicking Winamp's button styles and layout
**FR-6.4**: The app shall support Retina display rendering for crisp visuals
**FR-6.5**: The app shall maintain the compact, fixed-size window aesthetic of classic Winamp
**FR-6.6**: The app shall include a main window and a separate playlist window (can be toggled)

### 7. macOS System Integration
**FR-7.1**: The app shall respond to keyboard media keys (play/pause, next, previous)
**FR-7.2**: The app shall provide a menu bar icon with playback controls and track info
**FR-7.3**: The app shall display native macOS notifications for track changes
**FR-7.4**: The app shall provide Touch Bar controls on compatible MacBook models
**FR-7.5**: The app shall update macOS Now Playing info for Control Center and Lock Screen displays

## User Experience

### Main User Flows

**Flow 1: First Launch and Authentication**
1. User launches the app
2. App displays Winamp-styled welcome screen with "Connect to Spotify" button
3. User clicks button, browser opens with Spotify OAuth login
4. User authorizes the app
5. Browser redirects back to app with authentication tokens
6. App displays main player interface with user's library

**Flow 2: Playing a Playlist**
1. User opens playlist window from main player
2. User selects a playlist from their library
3. Playlist tracks display in Winamp-styled list view
4. User double-clicks a track or clicks play button
5. Track begins playing, main window updates with track info
6. LED display shows track time, progress bar fills
7. Album artwork displays in designated area

**Flow 3: Quick Playback Control from Menu Bar**
1. User clicks menu bar icon
2. Dropdown shows "Now Playing" info and mini controls
3. User clicks next track button
4. Playback advances, menu bar updates immediately
5. Notification appears showing new track info

### UI/UX Considerations

- **Authentic Winamp Aesthetic**: Pixel-accurate recreation of button styles, colors, and typography from the Classified v5.5 skin
- **Modern Adaptations**: Retina-optimized graphics, smooth animations, native macOS window behaviors
- **Responsive Feedback**: Immediate visual feedback for all button presses and interactions
- **Intuitive Navigation**: Clear visual hierarchy between main player, playlist window, and library sections
- **Keyboard Shortcuts**: Support for common shortcuts (space for play/pause, cmd+up/down for volume)

### Accessibility Requirements

- **FR-8.1**: The app shall support VoiceOver screen reader for all interactive elements
- **FR-8.2**: The app shall provide keyboard navigation for all functions
- **FR-8.3**: The app shall maintain sufficient color contrast ratios for text visibility
- **FR-8.4**: The app shall support macOS system font size preferences where applicable

## High-Level Technical Constraints

### Required Integrations
- **Spotify Web API**: Must use Spotify's official Web API for all music playback and library access
- **Spotify Web Playback SDK**: Required for actual audio playback in the browser or native player integration

### Platform Requirements
- **macOS Version**: Must support macOS 12.0 (Monterey) or later to ensure modern API availability
- **Native Development**: Must be built as a native macOS application (SwiftUI preferred for modern features)

### Authentication & Security
- **OAuth 2.0**: Must implement Spotify's OAuth flow following their guidelines
- **Keychain Storage**: Must store sensitive tokens in macOS Keychain, not in plain text
- **HTTPS Only**: All API communication must be encrypted

### Performance Requirements
- **Playback Latency**: Track should begin playing within 2 seconds of user action
- **UI Responsiveness**: All UI interactions should respond within 100ms
- **Memory Usage**: Should not exceed 200MB RAM under normal operation

### Connectivity
- **Online-Only**: App requires active internet connection for all functionality
- **Network Error Handling**: Must gracefully handle network failures and inform users

### Display Requirements
- **Retina Support**: All UI assets must support @2x and @3x resolutions for Retina displays
- **Fixed Window Size**: Main player window maintains consistent dimensions matching Winamp aesthetic

## Non-Goals (Out of Scope)

### Explicitly Excluded Features

1. **Social Features**: No collaborative playlists, friend activity, sharing, or social integration
2. **Podcast Support**: Music streaming only; no podcast playback or discovery
3. **Multi-Device Sync**: No syncing playback state or queue across multiple devices (Spotify Connect not supported)
4. **Audio Effects**: No equalizer, audio visualizations, or DSP effects processing
5. **Offline Playback**: No downloading or caching of tracks for offline listening
6. **Skin Customization**: No ability to load different skins or customize the Classified v5.5 appearance
7. **Music Discovery**: No "Discover Weekly," recommendations, or algorithmic playlists
8. **Lyrics Display**: No synchronized lyrics or karaoke features
9. **Radio/Autoplay**: No algorithmic song continuation after playlists end
10. **Local File Playback**: No support for playing local MP3/FLAC files outside of Spotify

### Future Considerations (Not in V1)
- Additional Winamp skin options
- Custom equalizer settings
- Music visualization plugins
- iOS/iPadOS companion app

## Open Questions

All requirements have been clarified through initial discovery. No open questions remaining for PRD scope.

If additional questions arise during technical specification or implementation:
- Refer back to the portfolio/learning project goal - prioritize learning and showcase value
- Maintain focus on core music playback experience over feature bloat
- Keep Winamp aesthetic authenticity as the guiding design principle

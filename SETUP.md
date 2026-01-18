# Setup Guide - Winamp Spotify Player for macOS

## Prerequisites

### 1. Development Environment
- macOS 12.0 (Monterey) or later
- Xcode 15.0+ with Swift 5.9+
- Spotify Premium account (required for Web Playback SDK)

### 2. Spotify Developer Account Setup

#### Step 1: Create Spotify App
1. Go to [Spotify Developer Dashboard](https://developer.spotify.com/dashboard)
2. Log in with your Spotify account
3. Click **"Create an App"**
4. Fill in the details:
   - **App name**: Winamp Spotify Player
   - **App description**: A Winamp-inspired Spotify player for macOS
   - **Redirect URIs**: `winampspotify://callback` (IMPORTANT!)
5. Accept terms and click **"Create"**

#### Step 2: Get Your Credentials
1. On your app's dashboard, find:
   - **Client ID** (visible)
   - **Client Secret** (click "Show Client Secret")
2. **IMPORTANT**: Keep these credentials secure

#### Step 3: Configure the App
Edit `WinampSpotifyPlayer/Core/SpotifyConfig.swift`:

```swift
static let clientID = "your_client_id_here"
static let clientSecret = "your_client_secret_here"
```

**OR** (recommended for security) set environment variables:
```bash
export SPOTIFY_CLIENT_ID="your_client_id_here"
export SPOTIFY_CLIENT_SECRET="your_client_secret_here"
```

## Building the Project

### Using Xcode

1. **Add Files to Xcode Project**
   - Open `WinampSpotifyPlayer.xcodeproj` in Xcode
   - **IMPORTANT**: The Swift files need to be added to the Xcode project
   - Right-click on "WinampSpotifyPlayer" group → "Add Files to WinampSpotifyPlayer..."
   - Navigate to the project directory
   - Select all folders:
     - `App/`
     - `Domain/`
     - `Data/`
     - `Presentation/`
     - `Core/`
     - `Services/`
   - Make sure "Copy items if needed" is **unchecked**
   - Make sure "Create groups" is selected
   - Click "Add"

2. **Add Resources**
   - Add the `Resources/SpotifySDK/player.html` file to the project
   - Ensure it's included in the app bundle

3. **Build the Project**
   - Select the WinampSpotifyPlayer scheme
   - Press `⌘+B` to build
   - Fix any remaining file reference issues

4. **Run the App**
   - Press `⌘+R` to run
   - The authentication screen should appear

### Using Swift Package Manager (for verification only)

```bash
cd WinampSpotifyPlayer
swift build
```

Note: SPM build excludes the App and Resources, so it's only for code verification.

## First Run

### 1. Launch the App
- The authentication screen will appear
- Click "Connect to Spotify"

### 2. Authenticate
- Your default browser will open
- Log in to Spotify if needed
- Click "Agree" to authorize the app
- The browser will redirect back to the app

### 3. Initialize Playback
- After authentication, the main player window appears
- Open the Library window (Window menu → Library)
- Select a playlist
- Click a track to play

## Permissions

The app will request the following macOS permissions:

### Notifications
- Grants permission to show "Now Playing" notifications
- Optional but recommended

### Accessibility (for Media Keys)
- Required for media key capture (play/pause, next, previous)
- Go to: **System Preferences → Security & Privacy → Privacy → Accessibility**
- Add and enable "WinampSpotifyPlayer"

## Troubleshooting

### Authentication Fails
**Problem**: "Invalid client" or redirect error

**Solution**:
1. Verify your Client ID and Client Secret in `SpotifyConfig.swift`
2. Ensure redirect URI is exactly `winampspotify://callback` in Spotify Dashboard
3. Check that the URL scheme is configured in `Info.plist`

### Playback Doesn't Start
**Problem**: Tracks don't play after clicking

**Solution**:
1. Ensure you have Spotify Premium (required for Web Playback SDK)
2. Check browser console in the hidden WebView (enable web inspector)
3. Verify access token is being set correctly

### Media Keys Don't Work
**Problem**: Keyboard media keys aren't captured

**Solution**:
1. Grant Accessibility permissions (see Permissions above)
2. Close other music apps that might capture media keys
3. Check that MediaKeyHandler is initialized in AppCoordinator

### Build Errors in Xcode
**Problem**: "Cannot find type" or "Cannot find in scope" errors

**Solution**:
1. Ensure all Swift files are added to the Xcode project target
2. Clean build folder: Product → Clean Build Folder (⇧⌘K)
3. Rebuild: ⌘+B

## Features Overview

### Main Player Window
- Track info with scrolling text
- Album artwork
- Progress bar with seek
- Playback controls (previous, play/pause, next)
- Shuffle and repeat buttons
- Volume slider

### Library Window
- Browse playlists
- View tracks in each playlist
- Click to play

### macOS Integration
- **Media Keys**: Control playback with keyboard media keys
- **Menu Bar**: Access controls from menu bar icon
- **Notifications**: "Now Playing" notifications
- **Control Center**: Track info in macOS Control Center

## Configuration Options

### Environment Variables
```bash
# Spotify credentials (recommended over hardcoding)
export SPOTIFY_CLIENT_ID="your_id"
export SPOTIFY_CLIENT_SECRET="your_secret"
```

### Build Configurations
In Xcode, you can create different schemes for:
- **Debug**: Development with console logging
- **Release**: Optimized build for distribution

## Next Steps

1. **Customize the UI**: Modify Winamp-styled components in `Presentation/Components/`
2. **Add Features**: Extend use cases in `Domain/UseCases/`
3. **Improve Performance**: Profile with Instruments
4. **Add Tests**: Expand unit tests in `WinampSpotifyPlayerTests/`

## Support

For issues or questions:
- Check the [README.md](README.md) for architecture details
- Review task documentation in `docs/` folder
- Check Spotify API documentation: https://developer.spotify.com/documentation/web-api

## Security Notes

⚠️ **NEVER commit your Spotify credentials to version control!**

- Use environment variables for credentials
- Add `SpotifyConfig.swift` to `.gitignore` if you hardcode credentials
- Rotate your Client Secret if accidentally exposed

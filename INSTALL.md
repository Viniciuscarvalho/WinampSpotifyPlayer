# Installation Guide - Winamp Spotify Player

## Overview
Winamp Spotify Player is a native macOS application that combines Winamp's classic aesthetic with Spotify streaming. This guide covers installation, configuration, and getting started.

---

## 📋 Prerequisites

Before installing, ensure you have:

- **macOS 12.0 (Monterey)** or later
- **Xcode 15.0+** with Command Line Tools
- **Spotify Premium** account (required for Web Playback SDK)
- **Spotify Developer** account (free)

---

## 🚀 Installation Methods

### Method 1: Download Pre-built DMG (Recommended)

**Easiest way to get started!**

#### Step 1: Download DMG

Visit the [Releases page](https://github.com/Viniciuscarvalho/WinampSpotifyPlayer/releases) and download the latest `WinampSpotifyPlayer.dmg`.

```bash
# Or download via command line
curl -L -o WinampSpotifyPlayer.dmg \
  https://github.com/Viniciuscarvalho/WinampSpotifyPlayer/releases/latest/download/WinampSpotifyPlayer.dmg
```

#### Step 2: Install Application

1. **Open the DMG file**
   ```bash
   open WinampSpotifyPlayer.dmg
   ```

2. **Drag WinampSpotifyPlayer.app to Applications folder**
   - A Finder window will open with the app and Applications folder shortcut
   - Drag the app icon to the Applications folder

3. **Launch the Application**
   ```bash
   open /Applications/WinampSpotifyPlayer.app
   ```

4. **First Launch (Gatekeeper)**

   If you see "WinampSpotifyPlayer can't be opened because it is from an unidentified developer":

   - **Option A**: Right-click (or Control+Click) on the app → Click **"Open"** → Click **"Open"** again
   - **Option B**: System Preferences → Security & Privacy → Click **"Open Anyway"**
   - **Option C**: Remove quarantine attribute:
     ```bash
     xattr -cr /Applications/WinampSpotifyPlayer.app
     ```

5. **Configure Spotify Credentials** (see Spotify Developer Setup section below)

#### Step 3: Verify Download (Optional but Recommended)

Verify the DMG integrity using the checksum file:

```bash
# Download checksum file
curl -L -o WinampSpotifyPlayer_dmg_checksum.txt \
  https://github.com/Viniciuscarvalho/WinampSpotifyPlayer/releases/latest/download/WinampSpotifyPlayer_dmg_checksum.txt

# Verify
shasum -a 256 -c WinampSpotifyPlayer_dmg_checksum.txt
```

You should see: `WinampSpotifyPlayer.dmg: OK`

---

### Method 2: Building from Source

#### Step 1: Clone the Repository
```bash
git clone https://github.com/Viniciuscarvalho/WinampSpotifyPlayer.git
cd WinampSpotifyPlayer
```

#### Step 2: Configure Spotify Credentials

**Option A: Environment Variables (Recommended)**
```bash
# Add to your ~/.zshrc or ~/.bash_profile
export SPOTIFY_CLIENT_ID="your_spotify_client_id_here"
export SPOTIFY_CLIENT_SECRET="your_spotify_client_secret_here"

# Reload your shell
source ~/.zshrc
```

**Option B: Direct Configuration**
Edit `WinampSpotifyPlayer/Core/SpotifyConfig.swift`:
```swift
static let clientID = "your_spotify_client_id_here"
static let clientSecret = "your_spotify_client_secret_here"
```

⚠️ **Security Note**: Never commit your credentials! Use environment variables or add `SpotifyConfig.swift` to `.gitignore`.

#### Step 3: Open in Xcode
```bash
open WinampSpotifyPlayer.xcodeproj
```

#### Step 4: Add Source Files to Project

Since the Swift files are not yet in the Xcode project target:

1. In Xcode, **right-click** on "WinampSpotifyPlayer" group
2. Select **"Add Files to WinampSpotifyPlayer..."**
3. Navigate to the project directory
4. **Select all source folders**:
   - `App/`
   - `Domain/`
   - `Data/`
   - `Presentation/`
   - `Core/`
   - `Services/`
   - `Resources/SpotifySDK/` (make sure `player.html` is included)
5. Ensure **"Copy items if needed"** is **unchecked**
6. Ensure **"Create groups"** is selected
7. Click **"Add"**

#### Step 5: Build and Run
```bash
# Build the project
⌘+B

# Or build from command line
xcodebuild -project WinampSpotifyPlayer.xcodeproj \
           -scheme WinampSpotifyPlayer \
           -configuration Release \
           build
```

#### Step 6: Run the Application
```bash
# From Xcode
⌘+R

# Or run the built app
open ~/Library/Developer/Xcode/DerivedData/WinampSpotifyPlayer-*/Build/Products/Release/WinampSpotifyPlayer.app
```

---

### Method 3: Build Your Own DMG (For Developers)

If you want to create your own distributable DMG:

```bash
# Clone repository
git clone https://github.com/Viniciuscarvalho/WinampSpotifyPlayer.git
cd WinampSpotifyPlayer

# Make scripts executable
chmod +x scripts/*.sh

# Build release
./scripts/build-release.sh

# Create DMG
./scripts/create-dmg.sh

# DMG will be at: build/WinampSpotifyPlayer.dmg
```

**With code signing** (requires Apple Developer ID):

```bash
# Set your Developer ID
export CODESIGN_IDENTITY="Developer ID Application: Your Name (TEAMID)"

# Build with signing
./scripts/build-release.sh

# Create DMG
./scripts/create-dmg.sh
```

---

## 🎵 Spotify Developer Setup

### Step 1: Create Spotify Application

1. Go to [Spotify Developer Dashboard](https://developer.spotify.com/dashboard)
2. Log in with your Spotify account
3. Click **"Create an App"**
4. Fill in:
   - **App Name**: Winamp Spotify Player
   - **App Description**: A Winamp-inspired Spotify player for macOS
   - **Website**: (optional)
   - **Redirect URIs**: `winampspotify://callback` ⚠️ **CRITICAL**
5. Accept terms and click **"Save"**

### Step 2: Get Your Credentials

1. On your app dashboard, copy:
   - **Client ID**
   - **Client Secret** (click "Show Client Secret")

2. Configure these in the app (see Installation Method 1, Step 2)

### Step 3: Verify Redirect URI

**Critical**: Ensure your Redirect URI is exactly:
```
winampspotify://callback
```

Without this, authentication will fail.

---

## 🎮 First Run

### 1. Launch the Application

After building and running:

```bash
# From Xcode
⌘+R

# From Applications folder (if installed)
open /Applications/WinampSpotifyPlayer.app
```

### 2. Authenticate with Spotify

<img src="docs/screenshots/auth-screen.png" alt="Authentication Screen" width="400"/>

1. Click **"Connect to Spotify"**
2. Your browser will open
3. Log in to Spotify (if needed)
4. Click **"Agree"** to authorize
5. Browser redirects back to app
6. Main player window appears

### 3. Grant Permissions

#### Notifications
- **Purpose**: Show "Now Playing" notifications
- **Action**: Click "Allow" when prompted

#### Accessibility (for Media Keys)
1. Go to **System Preferences → Security & Privacy → Privacy → Accessibility**
2. Click the **lock** to make changes
3. Click **"+"** and add **WinampSpotifyPlayer**
4. Check the box to enable

---

## 🎸 Using the Application

### Main Player Window

<img src="docs/screenshots/main-player.png" alt="Main Player" width="300"/>

The main player (300×400px) includes:
- 🎵 **Track Info**: Scrolling LED display
- 🖼️ **Album Art**: 100×100px artwork
- ▶️ **Playback Controls**: Previous, Play/Pause, Next
- 🔀 **Shuffle & Repeat**: Toggle modes
- 🎚️ **Volume Slider**: Vertical control
- ⏱️ **Progress Bar**: Click to seek

**Keyboard Shortcuts**:
- **Space**: Play/Pause
- **→**: Next track
- **←**: Previous track
- **↑**: Volume up
- **↓**: Volume down

### Library Window

<img src="docs/screenshots/library-window.png" alt="Library Window" width="700"/>

Access via **Window → Library** or **⌘+L**:
- 📚 Browse playlists (left panel)
- 🎵 View tracks (right panel)
- 🖱️ Double-click to play

### Menu Bar Integration

<img src="docs/screenshots/menu-bar.png" alt="Menu Bar" width="200"/>

Click the 🎵 icon for:
- Current track info
- Quick playback controls
- Quit option

### Media Keys

Use your keyboard's media keys:
- **Play/Pause**: ⏯️
- **Next Track**: ⏭️
- **Previous Track**: ⏮️

---

## 🔧 Advanced Configuration

### Uninstallation

#### Remove Application
```bash
# Remove app
rm -rf /Applications/WinampSpotifyPlayer.app

# Remove preferences
rm -rf ~/Library/Preferences/com.winamp-spotify-player.*

# Clear Keychain items
# Open Keychain Access app and search for "spotify" items to delete
```

#### Revoke Spotify Access
1. Go to [Spotify Account Settings](https://www.spotify.com/account/apps/)
2. Find "Winamp Spotify Player"
3. Click **"Remove Access"**

---

## 🐛 Troubleshooting

### Build Fails with "Cannot find in scope"

**Problem**: Xcode can't find types/files

**Solution**:
```bash
# Clean build folder
⌘+⇧+K (in Xcode)

# Or from terminal
xcodebuild clean -project WinampSpotifyPlayer.xcodeproj

# Ensure all Swift files are added to target
# Check File Inspector → Target Membership → WinampSpotifyPlayer
```

### Authentication Fails

**Problem**: "Invalid client" or redirect error

**Solution**:
1. Verify Client ID and Secret in `SpotifyConfig.swift`
2. Check redirect URI is exactly `winampspotify://callback`
3. Ensure URL scheme in `Info.plist` matches:
   ```xml
   <key>CFBundleURLSchemes</key>
   <array>
       <string>winampspotify</string>
   </array>
   ```

### No Sound / Playback Fails

**Problem**: Tracks don't play

**Solution**:
1. **Verify Spotify Premium**: Web Playback SDK requires Premium
2. Check Safari/WebKit is not blocking the SDK
3. Restart the app
4. Log out and log in again

### Media Keys Don't Work

**Problem**: Keyboard media keys aren't captured

**Solution**:
1. Grant Accessibility permission (see First Run section)
2. Close other music apps (Apple Music, Spotify app)
3. Restart WinampSpotifyPlayer

### High CPU Usage

**Problem**: App using excessive CPU

**Solution**:
1. Check Activity Monitor for `WinampSpotifyPlayer`
2. The WebView SDK can use ~5-10% CPU during playback (normal)
3. If higher, try:
   ```bash
   # Restart the app
   # Clear DerivedData
   rm -rf ~/Library/Developer/Xcode/DerivedData/WinampSpotifyPlayer-*
   ```

---

## 📊 System Requirements

| Requirement | Minimum | Recommended |
|-------------|---------|-------------|
| **macOS** | 12.0 (Monterey) | 13.0+ (Ventura) |
| **RAM** | 4 GB | 8 GB+ |
| **Disk Space** | 100 MB | 200 MB |
| **Display** | 1280×800 | Retina Display |
| **Internet** | Broadband | High-speed |
| **Spotify** | Premium | Premium |

---

## 🔒 Privacy & Security

### Data Storage
- **Tokens**: Stored securely in macOS Keychain
- **No Analytics**: Zero telemetry or tracking
- **Local Only**: All data stays on your Mac

### Permissions Required
- **Network**: Spotify API communication
- **Notifications**: Track change alerts (optional)
- **Accessibility**: Media key capture (optional)

### What We Don't Collect
- ❌ No usage analytics
- ❌ No personal information
- ❌ No listening history
- ❌ No third-party tracking

---

## 📚 Additional Resources

- **README**: [README.md](README.md) - Project overview
- **Setup Guide**: [SETUP.md](SETUP.md) - Detailed setup
- **Project Summary**: [PROJECT_SUMMARY.md](PROJECT_SUMMARY.md) - Implementation details
- **Documentation**: [docs/](docs/) - PRD, tech spec, tasks

---

## 🤝 Contributing

This is a portfolio/learning project, but contributions are welcome!

```bash
# Fork the repository
# Create a feature branch
git checkout -b feature/amazing-feature

# Commit your changes
git commit -m "Add amazing feature"

# Push to branch
git push origin feature/amazing-feature

# Open a Pull Request
```

---

## 📄 License

This is a portfolio/learning project. See individual dependencies for their licenses.

---

## 🙋 Support

- **Issues**: [GitHub Issues](https://github.com/Viniciuscarvalho/WinampSpotifyPlayer/issues)
- **Spotify API**: [Spotify Developer Docs](https://developer.spotify.com/documentation/)

---

**Made with ❤️ and nostalgia for Winamp**

*Winamp is a trademark of Radionomy. This project is not affiliated with or endorsed by Winamp, Radionomy, or Spotify.*

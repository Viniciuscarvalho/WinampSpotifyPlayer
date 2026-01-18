# 🎵 Winamp Spotify Player

<div align="center">

**Relive the glory days of Winamp while streaming from Spotify**

A native macOS music player that perfectly recreates the iconic Winamp interface with modern Spotify streaming.

[Features](#features) • [Installation](#installation) • [Setup](#spotify-setup) • [Screenshots](#screenshots) • [Build](#building-from-source)

</div>

---

## ✨ Features

### 🎨 **Authentic Winamp Experience**
- Pixel-perfect recreation of Winamp's Classified v5.5 skin
- Classic LED displays showing track info and time
- Original control button layout
- Nostalgic green monochrome aesthetic

### 🎵 **Full Spotify Integration**
- Stream your entire Spotify library
- Browse playlists, albums, and artists
- Play, pause, skip, shuffle, and repeat
- Volume control and seeking
- Requires Spotify Premium account

### 💻 **Deep macOS Integration**
- Media key support (play/pause, next, previous)
- Menu bar quick controls
- System notifications for track changes
- Control Center / Now Playing integration
- Works seamlessly with macOS 12.0+

---

## 📦 Installation

### Quick Install (Recommended)

1. **Download** the latest DMG from [Releases](https://github.com/Viniciuscarvalho/WinampSpotifyPlayer/releases)
2. **Open** the DMG file
3. **Drag** WinampSpotifyPlayer.app to your Applications folder
4. **Launch** the app (Right-click → Open on first launch)

That's it! Now proceed to [Spotify Setup](#spotify-setup).

---

## 🔐 Spotify Setup

Before you can use the app, you need to register it with Spotify:

### Step 1: Create Spotify Developer App

1. Go to [Spotify Developer Dashboard](https://developer.spotify.com/dashboard)
2. Click **"Create App"**
3. Fill in the details:
   - **App name**: Winamp Spotify Player (or any name)
   - **App description**: Personal music player
   - **Redirect URI**: `winampspotify://callback` ⚠️ **Must be exact**
4. Accept terms and click **"Save"**

### Step 2: Get Your Credentials

1. Click on your newly created app
2. Click **"Settings"**
3. Copy your **Client ID**
4. Click **"View client secret"** and copy it

### Step 3: Configure the App

On first launch, the app will ask for your credentials:
- Paste your **Client ID**
- Paste your **Client Secret**
- Click **"Save & Authenticate"**

You'll be redirected to Spotify to authorize the app. Done! 🎉

---

## 🎮 Usage

### Basic Controls

- **Play/Pause**: Click the play button or press Space
- **Next Track**: Click next button or press ⌘+→
- **Previous Track**: Click previous button or press ⌘+←
- **Volume**: Use the volume slider on the right
- **Seek**: Click on the progress bar

### Keyboard Shortcuts

- `Space` - Play/Pause
- `⌘+→` - Next Track
- `⌘+←` - Previous Track
- `⌘+↑` - Volume Up
- `⌘+↓` - Volume Down
- `⌘+L` - Open Library Window
- `⌘+Q` - Quit

### Media Keys

The app automatically captures your Mac's media keys:
- **Play/Pause** key
- **Next Track** key
- **Previous Track** key

---

## 📸 Screenshots

<!-- TODO: Add screenshots after UI redesign -->

*Screenshots coming soon...*

---

## 🛠 Building from Source

### Requirements

- macOS 12.0 (Monterey) or later
- Xcode 14.0 or later
- Swift 5.9+
- Spotify Premium account

### Build Steps

1. **Clone the repository**
   ```bash
   git clone https://github.com/Viniciuscarvalho/WinampSpotifyPlayer.git
   cd WinampSpotifyPlayer
   ```

2. **Open in Xcode**
   ```bash
   open WinampSpotifyPlayer.xcodeproj
   ```

3. **Build & Run**
   - Press `⌘+B` to build
   - Press `⌘+R` to run
   - Follow [Spotify Setup](#spotify-setup) on first launch

### Project Structure

```
WinampSpotifyPlayer/
├── App/                    # Application entry point
├── Domain/                 # Business logic & models
│   ├── Models/            # Track, Playlist, User, etc.
│   └── UseCases/          # Authentication, Playback, Library
├── Data/                   # Data layer
│   ├── Repositories/      # Spotify API & Keychain
│   └── DTOs/              # API response models
├── Presentation/           # UI layer
│   ├── Views/             # Main player, Playlist, Auth
│   ├── ViewModels/        # State management
│   └── Components/        # Reusable UI components
├── Core/                   # Networking, Keychain, Extensions
└── Services/               # Media keys, Notifications, Menu bar
```

---

## 🏗 Architecture

This project follows **Clean Architecture** principles with clear separation of concerns:

- **Domain Layer**: Pure business logic, no dependencies
- **Data Layer**: External integrations (Spotify API, Keychain)
- **Presentation Layer**: SwiftUI views and view models
- **Dependency Injection**: SwiftUI Environment-based DI

### Tech Stack

- **Language**: Swift 5.9+
- **UI Framework**: SwiftUI
- **Reactive Programming**: Combine
- **Architecture**: Clean Architecture (MVVM + Use Cases)
- **API Integration**: Spotify Web API + Web Playback SDK
- **Secure Storage**: macOS Keychain

---

## ⚠️ Requirements & Limitations

### Requirements
- ✅ macOS 12.0 (Monterey) or later
- ✅ Spotify Premium account (required for playback)
- ✅ Active internet connection

### Current Limitations
- ⚠️ Requires Spotify Premium (free accounts cannot stream)
- ⚠️ macOS only (no Windows/Linux support)
- ⚠️ Single window mode (no multiple instances)

---

## 🤝 Contributing

This is a personal learning project, but feedback and suggestions are welcome!

- 🐛 **Found a bug?** [Open an issue](https://github.com/Viniciuscarvalho/WinampSpotifyPlayer/issues)
- 💡 **Have an idea?** [Start a discussion](https://github.com/Viniciuscarvalho/WinampSpotifyPlayer/discussions)
- ⭐ **Like the project?** Give it a star!

---

## 📄 License

This is a portfolio/educational project. See individual dependencies for their licenses.

**Spotify** and the Spotify logo are registered trademarks of Spotify AB.
**Winamp** is a trademark of Radionomy SA.

This project is not affiliated with or endorsed by Spotify or Winamp.

---

## 🙏 Acknowledgments

- Original Winamp design by Nullsoft/Radionomy
- Spotify Web API & Web Playback SDK
- Classic Winamp v5.5 Classified skin inspiration

---

<div align="center">

**Built with ❤️ using Swift & SwiftUI**

Made by [Vinicius Carvalho](https://github.com/Viniciuscarvalho)

</div>

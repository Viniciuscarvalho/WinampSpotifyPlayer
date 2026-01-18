# Task 1.0: Project Initialization & Architecture Setup

**Important:** Read the prd.md and techspec.md files in this folder before starting.

## Overview

Set up the Xcode project with Clean Architecture folder structure, configure build settings for macOS 12.0+ deployment, and establish the foundational project configuration including custom URL scheme for OAuth callback.

## Requirements

- Xcode 15.0+ installed
- macOS development certificate
- Swift 5.9+ support
- Clean Architecture folder structure (Domain/Data/Presentation/Core/Services)

## Subtasks

- [ ] 1.1 Create new macOS Xcode project named "WinampSpotifyPlayer"
- [ ] 1.2 Set deployment target to macOS 12.0 (Monterey)
- [ ] 1.3 Configure custom URL scheme `winampspotify://callback` in Info.plist
- [ ] 1.4 Create Clean Architecture folder structure
- [ ] 1.5 Set up unit testing target with proper configuration
- [ ] 1.6 Configure build settings (Swift version, optimization levels)
- [ ] 1.7 Create .gitignore for Xcode projects
- [ ] 1.8 Initialize Git repository with initial commit

## Implementation Details

### Folder Structure to Create:
```
WinampSpotifyPlayer/
├── App/
│   ├── WinampSpotifyPlayerApp.swift
│   └── AppDelegate.swift
├── Domain/
│   ├── Models/
│   └── UseCases/
├── Data/
│   ├── Repositories/
│   └── DTOs/
├── Presentation/
│   ├── Views/
│   ├── ViewModels/
│   └── Components/
├── Core/
│   ├── Networking/
│   ├── Keychain/
│   └── Extensions/
├── Services/
└── Resources/
    ├── Assets.xcassets/
    ├── SpotifySDK/
    └── Info.plist
```

### Info.plist Configuration:
Add URL scheme under `CFBundleURLTypes`:
```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>winampspotify</string>
        </array>
        <key>CFBundleURLName</key>
        <string>com.yourcompany.winamp-spotify-player</string>
    </dict>
</array>
```

## Success Criteria

- Project builds successfully without errors
- Deployment target set to macOS 12.0+
- All folder structure created and organized according to Clean Architecture
- Custom URL scheme `winampspotify://` registered in Info.plist
- Unit testing target configured and can run empty tests
- Git repository initialized with .gitignore
- Can launch empty app on macOS simulator/device

## Dependencies

None - This is the first task

## Relevant Files

- `WinampSpotifyPlayer.xcodeproj`
- `WinampSpotifyPlayer/Info.plist`
- `WinampSpotifyPlayer/App/WinampSpotifyPlayerApp.swift`
- `.gitignore`

## Task Context

| Property | Value |
|----------|-------|
| Domain | infrastructure |
| Type | implementation |
| Scope | project_setup |
| Complexity | medium |
| Dependencies | none |

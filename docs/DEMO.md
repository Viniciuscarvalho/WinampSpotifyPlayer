# Creating Demo Materials

This guide explains how to create demo screenshots and GIFs for WinampSpotifyPlayer.

## 📸 Screenshots

### Required Screenshots

1. **auth-screen.png** - Authentication screen
2. **main-player.png** - Main player window (300×400)
3. **library-window.png** - Playlist browser (700×500)
4. **menu-bar.png** - Menu bar integration

### Taking Screenshots

#### macOS Built-in Tool
```bash
# Full window screenshot
⌘+⇧+4, then Space, then click window

# Selection screenshot
⌘+⇧+4, then drag to select area

# Save to clipboard (add Ctrl)
⌘+Ctrl+⇧+4
```

#### Using Screenshot App
```bash
# Open Screenshot app
⌘+⇧+5

# Options:
# - Capture Selected Window
# - Capture Selected Portion
# - Record Selected Portion (for GIF)
```

### Screenshot Specifications

| Screenshot | Size | Description |
|------------|------|-------------|
| auth-screen.png | 500×600 | Authentication view |
| main-player.png | 300×400 | Player window |
| library-window.png | 700×500 | Library browser |
| menu-bar.png | 200×300 | Menu bar dropdown |

---

## 🎬 Creating a Demo GIF

### Method 1: Using QuickTime + Gifski

#### Step 1: Record with QuickTime
```bash
# Open QuickTime Player
open -a "QuickTime Player"

# File → New Screen Recording
# Select the app window
# Record 30-60 seconds of usage
# Save as demo.mov
```

#### Step 2: Convert to GIF with Gifski
```bash
# Install Gifski
brew install gifski

# Convert to GIF (adjust fps for size)
gifski demo.mov -o demo.gif --fps 15 --quality 90 --width 800

# For smaller file size
gifski demo.mov -o demo-small.gif --fps 10 --quality 80 --width 600
```

### Method 2: Using LICEcap (Free)

```bash
# Install LICEcap
brew install --cask licecap

# Open LICEcap
open -a LICEcap

# Steps:
# 1. Resize capture area to fit player window
# 2. Set max FPS to 15-20
# 3. Click "Record"
# 4. Demonstrate features for 30-60 seconds
# 5. Click "Stop"
# 6. Save as demo.gif
```

### Method 3: Using Kap (Modern, Recommended)

```bash
# Install Kap
brew install --cask kap

# Open Kap
open -a Kap

# Features:
# - Higher quality GIFs
# - Export options (GIF, MP4, WebM)
# - Cropping and trimming
# - Plugin support
```

---

## 🎥 Demo Script

Follow this sequence for a comprehensive demo:

### Part 1: Authentication (10 seconds)
1. Launch app
2. Show authentication screen
3. Click "Connect to Spotify"
4. Browser opens (show briefly)
5. Return to app (authenticated)

### Part 2: Main Player (20 seconds)
1. Show main player window
2. Track info scrolling
3. Album artwork
4. Click Play/Pause
5. Adjust volume
6. Click Next track
7. Show progress bar seek

### Part 3: Library Browser (15 seconds)
1. Open Library window (⌘+L)
2. Show playlist list
3. Click a playlist
4. Show tracks loading
5. Click a track to play
6. Switch back to main player

### Part 4: macOS Integration (15 seconds)
1. Click menu bar icon
2. Show menu dropdown
3. Use media keys (show on screen)
4. Show notification popup
5. Show Control Center integration

**Total Duration**: ~60 seconds

---

## 🎨 Demo GIF Optimization

### Reduce File Size

```bash
# Using gifsicle
brew install gifsicle

# Optimize existing GIF
gifsicle -O3 --lossy=80 -o demo-optimized.gif demo.gif

# Reduce colors for smaller size
gifsicle --colors 128 -O3 -o demo-128.gif demo.gif
```

### Target Specifications

| Type | Resolution | FPS | Duration | Max Size |
|------|-----------|-----|----------|----------|
| Full Demo | 800×600 | 15 | 60s | 10 MB |
| Quick Demo | 600×450 | 12 | 30s | 5 MB |
| Feature Highlight | 400×300 | 10 | 15s | 2 MB |

---

## 📝 Creating the Demo

### Quick Demo Script (30 seconds)

```bash
#!/bin/bash
# demo-recording.sh

echo "🎬 Starting demo recording in 3 seconds..."
sleep 3

# Step 1: Launch app (if not running)
open -a WinampSpotifyPlayer

echo "📱 Demo Part 1: Show authentication"
sleep 5

echo "🎵 Demo Part 2: Show player controls"
sleep 10

echo "📚 Demo Part 3: Show library"
sleep 10

echo "🎹 Demo Part 4: Show media keys"
sleep 5

echo "✅ Demo complete! Stop recording."
```

### Detailed Demo Checklist

- [ ] Clean slate (fresh launch)
- [ ] Authentication flow
- [ ] Main player window
  - [ ] Track info scrolling
  - [ ] Album artwork
  - [ ] Play/Pause animation
  - [ ] Progress bar seek
  - [ ] Volume control
  - [ ] Shuffle/Repeat toggle
- [ ] Library window
  - [ ] Playlist list
  - [ ] Track list
  - [ ] Click to play
- [ ] Menu bar integration
  - [ ] Icon
  - [ ] Menu dropdown
  - [ ] Track info
- [ ] macOS features
  - [ ] Media keys (on-screen display)
  - [ ] Notification popup
  - [ ] Control Center

---

## 🖼️ Adding to README

After creating demo materials:

1. **Copy screenshots to repository**
   ```bash
   cp ~/Desktop/auth-screen.png docs/screenshots/
   cp ~/Desktop/main-player.png docs/screenshots/
   cp ~/Desktop/library-window.png docs/screenshots/
   cp ~/Desktop/menu-bar.png docs/screenshots/
   ```

2. **Add demo GIF**
   ```bash
   cp ~/Desktop/demo.gif docs/demo.gif
   ```

3. **Update README.md**
   ```markdown
   ## 🎬 Demo

   ![Demo](docs/demo.gif)

   ## 📸 Screenshots

   <table>
   <tr>
     <td><img src="docs/screenshots/main-player.png" width="300"/></td>
     <td><img src="docs/screenshots/library-window.png" width="400"/></td>
   </tr>
   <tr>
     <td align="center">Main Player</td>
     <td align="center">Library Browser</td>
   </tr>
   </table>
   ```

---

## 🎯 GitHub Repository Setup

### Add to .gitattributes
```bash
# Create/edit .gitattributes
cat >> .gitattributes << 'EOF'
# Images
*.png filter=lfs diff=lfs merge=lfs -text
*.jpg filter=lfs diff=lfs merge=lfs -text
*.gif filter=lfs diff=lfs merge=lfs -text
EOF
```

### If using Git LFS for large files
```bash
# Install Git LFS
brew install git-lfs
git lfs install

# Track large files
git lfs track "*.gif"
git lfs track "*.png"

# Commit
git add .gitattributes
git commit -m "Configure Git LFS for media files"
```

---

## 💡 Tips for Great Demos

1. **Clean Desktop**: Hide distractions
2. **Dark Mode**: Matches Winamp aesthetic
3. **No Notifications**: Enable Do Not Disturb
4. **Smooth Cursor**: Slow down mouse movements
5. **Highlight Actions**: Brief pauses before clicks
6. **Test Run**: Practice before recording
7. **Good Music**: Use recognizable songs (with permission)
8. **Short & Sweet**: 30-60 seconds max

---

## 🎨 Placeholder Images

Until real screenshots are created, you can generate placeholders:

```bash
# Using ImageMagick
brew install imagemagick

# Auth screen placeholder
convert -size 500x600 xc:black \
        -fill green -font "Monaco" -pointsize 24 \
        -gravity center -draw "text 0,0 'Authentication\nScreen'" \
        docs/screenshots/auth-screen-placeholder.png

# Main player placeholder
convert -size 300x400 xc:black \
        -fill green -font "Monaco" -pointsize 18 \
        -gravity center -draw "text 0,0 'Main Player\nWindow'" \
        docs/screenshots/main-player-placeholder.png
```

---

**Note**: Replace placeholders with actual screenshots once the app is running!

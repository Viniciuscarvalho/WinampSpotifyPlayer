//
//  MenuBarManager.swift
//  WinampSpotifyPlayer
//
//  Created on 2026-01-18.
//

import Foundation
import Cocoa
import SwiftUI

/// Manages the menu bar icon and popover
@MainActor
final class MenuBarManager: NSObject {
    private var statusItem: NSStatusItem?
    private var playerViewModel: PlayerViewModel?

    func setup(playerViewModel: PlayerViewModel) {
        self.playerViewModel = playerViewModel

        // Create status item
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)

        if let button = statusItem?.button {
            button.image = NSImage(systemSymbolName: "music.note", accessibilityDescription: "Winamp Spotify Player")
            button.action = #selector(togglePopover)
            button.target = self
        }

        updateStatusItemTitle()
    }

    func updateStatusItemTitle() {
        guard let viewModel = playerViewModel else { return }

        if let track = viewModel.currentTrack {
            statusItem?.button?.toolTip = "\(track.name) - \(track.artistNamesString)"
        } else {
            statusItem?.button?.toolTip = "Winamp Spotify Player"
        }
    }

    @objc private func togglePopover() {
        // Show menu with current track info and controls
        let menu = NSMenu()

        // Track info
        if let track = playerViewModel?.currentTrack {
            let trackItem = NSMenuItem(title: track.name, action: nil, keyEquivalent: "")
            trackItem.isEnabled = false
            menu.addItem(trackItem)

            let artistItem = NSMenuItem(title: track.artistNamesString, action: nil, keyEquivalent: "")
            artistItem.isEnabled = false
            menu.addItem(artistItem)

            menu.addItem(NSMenuItem.separator())
        }

        // Playback controls
        let playPauseTitle = playerViewModel?.isPlaying == true ? "Pause" : "Play"
        let playPauseItem = NSMenuItem(title: playPauseTitle, action: #selector(playPauseAction), keyEquivalent: "")
        playPauseItem.target = self
        menu.addItem(playPauseItem)

        let nextItem = NSMenuItem(title: "Next Track", action: #selector(nextAction), keyEquivalent: "")
        nextItem.target = self
        menu.addItem(nextItem)

        let previousItem = NSMenuItem(title: "Previous Track", action: #selector(previousAction), keyEquivalent: "")
        previousItem.target = self
        menu.addItem(previousItem)

        menu.addItem(NSMenuItem.separator())

        // Quit
        let quitItem = NSMenuItem(title: "Quit", action: #selector(quitAction), keyEquivalent: "q")
        quitItem.target = self
        menu.addItem(quitItem)

        statusItem?.menu = menu
        statusItem?.button?.performClick(nil)
        statusItem?.menu = nil
    }

    @objc private func playPauseAction() {
        playerViewModel?.togglePlayPause()
    }

    @objc private func nextAction() {
        playerViewModel?.skipNext()
    }

    @objc private func previousAction() {
        playerViewModel?.skipPrevious()
    }

    @objc private func quitAction() {
        NSApplication.shared.terminate(nil)
    }
}

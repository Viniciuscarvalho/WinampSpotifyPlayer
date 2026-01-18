//
//  AppDelegate.swift
//  WinampSpotifyPlayer
//
//  Created on 2026-01-18.
//

import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Initial application setup
        print("WinampSpotifyPlayer launched successfully")
    }

    func applicationWillTerminate(_ notification: Notification) {
        // Cleanup before app terminates
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }

    // Handle custom URL scheme callback for Spotify OAuth
    func application(_ application: NSApplication, open urls: [URL]) {
        for url in urls {
            if url.scheme == "winampspotify" {
                print("Received OAuth callback: \(url)")
                // Will be handled by SpotifyAuthUseCase in future tasks
            }
        }
    }
}

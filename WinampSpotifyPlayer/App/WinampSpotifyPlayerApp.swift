//
//  WinampSpotifyPlayerApp.swift
//  WinampSpotifyPlayer
//
//  Created on 2026-01-18.
//

import SwiftUI

@main
struct WinampSpotifyPlayerApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .windowStyle(.hiddenTitleBar)
    }
}

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "music.note")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Winamp Spotify Player")
                .font(.headline)
            Text("Project initialized successfully")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(width: 300, height: 200)
    }
}

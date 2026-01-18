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
    @StateObject private var coordinator = AppCoordinator()

    var body: some Scene {
        WindowGroup {
            if coordinator.isAuthenticated {
                MainPlayerView(viewModel: coordinator.playerViewModel)
            } else {
                AuthenticationView(viewModel: coordinator.authViewModel)
            }
        }
        .windowStyle(.hiddenTitleBar)

        WindowGroup("Library") {
            PlaylistWindowView(
                viewModel: coordinator.libraryViewModel,
                playerViewModel: coordinator.playerViewModel
            )
        }
        .windowStyle(.hiddenTitleBar)
    }
}

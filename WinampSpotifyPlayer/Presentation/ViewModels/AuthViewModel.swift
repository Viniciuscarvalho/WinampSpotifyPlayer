//
//  AuthViewModel.swift
//  WinampSpotifyPlayer
//
//  Created on 2026-01-18.
//

import Foundation
import Combine

/// View model for authentication flow
@MainActor
final class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var isAuthenticating = false
    @Published var errorMessage: String?
    @Published var currentUser: User?

    private let authUseCase: SpotifyAuthUseCaseProtocol
    private var cancellables = Set<AnyCancellable>()

    init(authUseCase: SpotifyAuthUseCaseProtocol) {
        self.authUseCase = authUseCase
        checkAuthenticationStatus()
    }

    /// Checks if user is already authenticated
    func checkAuthenticationStatus() {
        isAuthenticated = authUseCase.isAuthenticated
    }

    /// Initiates Spotify authentication flow
    func authenticate() {
        Task {
            isAuthenticating = true
            errorMessage = nil

            do {
                let user = try await authUseCase.authenticate()
                currentUser = user
                isAuthenticated = true
            } catch {
                errorMessage = error.localizedDescription
                isAuthenticated = false
            }

            isAuthenticating = false
        }
    }

    /// Logs out the current user
    func logout() {
        Task {
            do {
                try await authUseCase.logout()
                currentUser = nil
                isAuthenticated = false
                errorMessage = nil
            } catch {
                errorMessage = "Logout failed: \(error.localizedDescription)"
            }
        }
    }
}

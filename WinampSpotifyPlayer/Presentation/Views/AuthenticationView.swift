//
//  AuthenticationView.swift
//  WinampSpotifyPlayer
//
//  Created on 2026-01-18.
//

import SwiftUI

/// Initial authentication view with Winamp-inspired styling
struct AuthenticationView: View {
    @StateObject var viewModel: AuthViewModel

    var body: some View {
        ZStack {
            // Dark background
            Color.black
                .ignoresSafeArea()

            VStack(spacing: 30) {
                // Logo/Title area
                VStack(spacing: 10) {
                    Image(systemName: "music.note.list")
                        .font(.system(size: 60))
                        .foregroundColor(.green)

                    Text("WINAMP")
                        .font(.system(size: 32, weight: .bold, design: .monospaced))
                        .foregroundColor(.green)

                    Text("SPOTIFY PLAYER")
                        .font(.system(size: 14, weight: .medium, design: .monospaced))
                        .foregroundColor(.gray)
                }

                // Description
                Text("Connect to Spotify to start playing music")
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)

                // Login button
                Button(action: {
                    viewModel.authenticate()
                }) {
                    HStack {
                        if viewModel.isAuthenticating {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .black))
                                .scaleEffect(0.8)
                        } else {
                            Image(systemName: "person.circle.fill")
                        }

                        Text(viewModel.isAuthenticating ? "Connecting..." : "Connect to Spotify")
                            .font(.system(size: 14, weight: .semibold))
                    }
                    .foregroundColor(.black)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 12)
                    .background(Color.green)
                    .cornerRadius(6)
                }
                .disabled(viewModel.isAuthenticating)
                .buttonStyle(PlainButtonStyle())

                // Error message
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .font(.system(size: 11))
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }

                Spacer()

                // Setup instructions
                VStack(spacing: 8) {
                    Text("First time setup:")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.gray)

                    VStack(alignment: .leading, spacing: 4) {
                        instructionText("1. Create a Spotify Developer account")
                        instructionText("2. Register a new application")
                        instructionText("3. Add 'winampspotify://callback' to Redirect URIs")
                        instructionText("4. Update SpotifyConfig.swift with your credentials")
                    }
                    .padding(.horizontal, 40)
                }
                .padding(.bottom, 20)
            }
            .padding()
        }
        .frame(width: 500, height: 600)
    }

    private func instructionText(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 10))
            .foregroundColor(.gray.opacity(0.7))
    }
}

struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationView(
            viewModel: AuthViewModel(
                authUseCase: PreviewMocks.authUseCase
            )
        )
    }
}

// MARK: - Preview Mocks

private struct PreviewMocks {
    static var authUseCase: SpotifyAuthUseCaseProtocol {
        MockAuthUseCase()
    }
}

private class MockAuthUseCase: SpotifyAuthUseCaseProtocol {
    var isAuthenticated: Bool = false

    func authenticate() async throws -> User {
        try await Task.sleep(nanoseconds: 1_000_000_000)
        return User.preview
    }

    func refreshAccessToken() async throws {}
    func logout() async throws {}
}

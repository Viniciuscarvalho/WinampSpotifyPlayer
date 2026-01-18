// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "WinampSpotifyPlayer",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        .library(
            name: "WinampSpotifyPlayer",
            targets: ["WinampSpotifyPlayer"]),
    ],
    targets: [
        .target(
            name: "WinampSpotifyPlayer",
            dependencies: [],
            path: "WinampSpotifyPlayer",
            exclude: [
                "Resources",
                "App"
            ]
        ),
    ]
)

//
//  APIError.swift
//  WinampSpotifyPlayer
//
//  Created on 2026-01-18.
//

import Foundation

/// Errors that can occur during API requests
enum APIError: Error, LocalizedError {
    /// Invalid request (400)
    case badRequest(String?)

    /// Authentication required or failed (401)
    case unauthorized

    /// Access forbidden (403)
    case forbidden

    /// Resource not found (404)
    case notFound

    /// Rate limit exceeded (429)
    case rateLimitExceeded(retryAfter: Int?)

    /// Server error (500-599)
    case serverError(statusCode: Int)

    /// Service unavailable (503)
    case serviceUnavailable

    /// Network connection error
    case networkError(Error)

    /// Invalid response from server
    case invalidResponse

    /// Failed to decode response
    case decodingError(Error)

    /// Invalid URL
    case invalidURL

    /// Unknown error
    case unknown(Error)

    var errorDescription: String? {
        switch self {
        case .badRequest(let message):
            return "Bad request: \(message ?? "Invalid parameters")"
        case .unauthorized:
            return "Authentication required or token expired"
        case .forbidden:
            return "Access to this resource is forbidden"
        case .notFound:
            return "The requested resource was not found"
        case .rateLimitExceeded(let retryAfter):
            if let seconds = retryAfter {
                return "Rate limit exceeded. Retry after \(seconds) seconds"
            }
            return "Rate limit exceeded. Please try again later"
        case .serverError(let statusCode):
            return "Server error (status code: \(statusCode))"
        case .serviceUnavailable:
            return "Service is temporarily unavailable"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .invalidResponse:
            return "Invalid response from server"
        case .decodingError(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        case .invalidURL:
            return "Invalid URL"
        case .unknown(let error):
            return "Unknown error: \(error.localizedDescription)"
        }
    }

    /// Whether this error can be retried
    var isRetryable: Bool {
        switch self {
        case .rateLimitExceeded, .serviceUnavailable, .serverError, .networkError:
            return true
        case .unauthorized, .forbidden, .notFound, .badRequest, .invalidResponse, .decodingError, .invalidURL, .unknown:
            return false
        }
    }
}

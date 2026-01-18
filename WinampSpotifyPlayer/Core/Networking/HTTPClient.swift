//
//  HTTPClient.swift
//  WinampSpotifyPlayer
//
//  Created on 2026-01-18.
//

import Foundation

/// Protocol for HTTP client (enables testing with mocks)
protocol HTTPClientProtocol {
    func request<T: Decodable>(
        _ endpoint: String,
        method: HTTPMethod,
        headers: [String: String]?,
        queryItems: [URLQueryItem]?
    ) async throws -> T
}

/// HTTP methods
enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

/// HTTP client wrapper around URLSession
final class HTTPClient: HTTPClientProtocol {
    private let session: URLSession
    private let baseURL: String

    /// Initializes the HTTP client
    /// - Parameters:
    ///   - baseURL: Base URL for all requests
    ///   - session: URLSession to use (defaults to shared)
    init(baseURL: String = "https://api.spotify.com/v1", session: URLSession = .shared) {
        self.baseURL = baseURL
        self.session = session
    }

    /// Makes an HTTP request and decodes the response
    /// - Parameters:
    ///   - endpoint: API endpoint path (e.g., "/me")
    ///   - method: HTTP method
    ///   - headers: Optional HTTP headers
    ///   - queryItems: Optional URL query parameters
    /// - Returns: Decoded response object
    func request<T: Decodable>(
        _ endpoint: String,
        method: HTTPMethod = .get,
        headers: [String: String]? = nil,
        queryItems: [URLQueryItem]? = nil
    ) async throws -> T {
        // Build URL
        guard var urlComponents = URLComponents(string: baseURL + endpoint) else {
            throw APIError.invalidURL
        }

        if let queryItems = queryItems, !queryItems.isEmpty {
            urlComponents.queryItems = queryItems
        }

        guard let url = urlComponents.url else {
            throw APIError.invalidURL
        }

        // Build request
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.timeoutInterval = 30

        // Add headers
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        headers?.forEach { key, value in
            request.addValue(value, forHTTPHeaderField: key)
        }

        // Execute request
        let (data, response) = try await performRequest(request)

        // Handle HTTP response
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        try handleHTTPStatus(httpResponse)

        // Decode response
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            throw APIError.decodingError(error)
        }
    }

    /// Performs the URLSession request with error handling
    private func performRequest(_ request: URLRequest) async throws -> (Data, URLResponse) {
        do {
            return try await session.data(for: request)
        } catch {
            throw APIError.networkError(error)
        }
    }

    /// Handles HTTP status codes and throws appropriate errors
    private func handleHTTPStatus(_ response: HTTPURLResponse) throws {
        switch response.statusCode {
        case 200...299:
            return

        case 400:
            // Try to extract error message from response
            throw APIError.badRequest(nil)

        case 401:
            throw APIError.unauthorized

        case 403:
            throw APIError.forbidden

        case 404:
            throw APIError.notFound

        case 429:
            // Rate limit exceeded - check Retry-After header
            let retryAfter = (response.allHeaderFields["Retry-After"] as? String)
                .flatMap { Int($0) }
            throw APIError.rateLimitExceeded(retryAfter: retryAfter)

        case 503:
            throw APIError.serviceUnavailable

        case 500...599:
            throw APIError.serverError(statusCode: response.statusCode)

        default:
            throw APIError.invalidResponse
        }
    }
}

// Extension removed - allHeaderFields property used instead

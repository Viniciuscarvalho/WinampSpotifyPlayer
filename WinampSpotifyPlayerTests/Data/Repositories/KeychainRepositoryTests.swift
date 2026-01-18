//
//  KeychainRepositoryTests.swift
//  WinampSpotifyPlayerTests
//
//  Created on 2026-01-18.
//

import XCTest
@testable import WinampSpotifyPlayer

final class KeychainRepositoryTests: XCTestCase {
    var sut: KeychainRepository!
    var keychainService: KeychainService!

    override func setUpWithError() throws {
        super.setUp()
        // Use a test service to avoid conflicts with production data
        keychainService = KeychainService(service: "com.winamp-spotify-player.test")
        sut = KeychainRepository(keychainService: keychainService)

        // Clean up any existing test data
        try? sut.deleteTokens()
    }

    override func tearDownWithError() throws {
        // Clean up test data
        try? sut.deleteTokens()
        sut = nil
        keychainService = nil
        super.tearDown()
    }

    // MARK: - Access Token Tests

    func testSaveAccessToken_Success() throws {
        // Given
        let testToken = "test_access_token_12345"

        // When
        try sut.save(accessToken: testToken)

        // Then
        let retrievedToken = try sut.getAccessToken()
        XCTAssertEqual(retrievedToken, testToken)
    }

    func testSaveAccessToken_UpdatesExisting() throws {
        // Given
        let firstToken = "first_token"
        let secondToken = "second_token"

        // When
        try sut.save(accessToken: firstToken)
        try sut.save(accessToken: secondToken)

        // Then
        let retrievedToken = try sut.getAccessToken()
        XCTAssertEqual(retrievedToken, secondToken)
    }

    func testGetAccessToken_ReturnsNilWhenNotFound() throws {
        // When
        let token = try sut.getAccessToken()

        // Then
        XCTAssertNil(token)
    }

    // MARK: - Refresh Token Tests

    func testSaveRefreshToken_Success() throws {
        // Given
        let testToken = "test_refresh_token_67890"

        // When
        try sut.save(refreshToken: testToken)

        // Then
        let retrievedToken = try sut.getRefreshToken()
        XCTAssertEqual(retrievedToken, testToken)
    }

    func testSaveRefreshToken_UpdatesExisting() throws {
        // Given
        let firstToken = "first_refresh_token"
        let secondToken = "second_refresh_token"

        // When
        try sut.save(refreshToken: firstToken)
        try sut.save(refreshToken: secondToken)

        // Then
        let retrievedToken = try sut.getRefreshToken()
        XCTAssertEqual(retrievedToken, secondToken)
    }

    func testGetRefreshToken_ReturnsNilWhenNotFound() throws {
        // When
        let token = try sut.getRefreshToken()

        // Then
        XCTAssertNil(token)
    }

    // MARK: - Delete Tests

    func testDeleteTokens_RemovesBothTokens() throws {
        // Given
        try sut.save(accessToken: "access_token")
        try sut.save(refreshToken: "refresh_token")

        // When
        try sut.deleteTokens()

        // Then
        let accessToken = try sut.getAccessToken()
        let refreshToken = try sut.getRefreshToken()
        XCTAssertNil(accessToken)
        XCTAssertNil(refreshToken)
    }

    func testDeleteTokens_SucceedsWhenNoTokensExist() throws {
        // When/Then - should not throw
        XCTAssertNoThrow(try sut.deleteTokens())
    }

    // MARK: - Persistence Tests

    func testTokensPersistAcrossInstances() throws {
        // Given
        let testAccessToken = "persistent_access_token"
        let testRefreshToken = "persistent_refresh_token"
        try sut.save(accessToken: testAccessToken)
        try sut.save(refreshToken: testRefreshToken)

        // When - Create new repository instance
        let newRepository = KeychainRepository(keychainService: keychainService)

        // Then
        let retrievedAccessToken = try newRepository.getAccessToken()
        let retrievedRefreshToken = try newRepository.getRefreshToken()
        XCTAssertEqual(retrievedAccessToken, testAccessToken)
        XCTAssertEqual(retrievedRefreshToken, testRefreshToken)
    }

    // MARK: - Edge Cases

    func testSaveEmptyString() throws {
        // Given
        let emptyToken = ""

        // When
        try sut.save(accessToken: emptyToken)

        // Then
        let retrievedToken = try sut.getAccessToken()
        XCTAssertEqual(retrievedToken, emptyToken)
    }

    func testSaveVeryLongToken() throws {
        // Given
        let longToken = String(repeating: "a", count: 10000)

        // When
        try sut.save(accessToken: longToken)

        // Then
        let retrievedToken = try sut.getAccessToken()
        XCTAssertEqual(retrievedToken, longToken)
    }

    func testSaveTokenWithSpecialCharacters() throws {
        // Given
        let specialToken = "token_with_!@#$%^&*()_+-=[]{}|;':\",./<>?"

        // When
        try sut.save(accessToken: specialToken)

        // Then
        let retrievedToken = try sut.getAccessToken()
        XCTAssertEqual(retrievedToken, specialToken)
    }
}

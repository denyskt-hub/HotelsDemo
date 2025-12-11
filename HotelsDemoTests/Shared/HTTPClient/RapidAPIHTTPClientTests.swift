//
//  RapidAPIHTTPClientTests.swift
//  HotelsDemoTests
//
//  Created by Denys Kotenko on 3/7/25.
//

import XCTest
import HotelsDemo

@MainActor
final class RapidAPIHTTPClientTests: XCTestCase {
	func test_perform_addsRapidAPIHeaders() async throws {
		let (sut, client) = makeSUT(apiHost: "test-host", apiKey: "test-key")

		client.completeWith((anyData(), makeHTTPURLResponse(statusCode: 200)))
		let dummyRequest = URLRequest(url: URL(string: "https://example.com")!)
		_ = try await sut.perform(dummyRequest)

		let headers = client.receivedRequests().first?.allHTTPHeaderFields
		XCTAssertEqual(headers?["X-RapidAPI-Host"], "test-host")
		XCTAssertEqual(headers?["X-RapidAPI-Key"], "test-key")
	}

	// MARK: - Helpers

	private func makeSUT(
		apiHost: String,
		apiKey: String
	) -> (
		sut: RapidAPIHTTPClient,
		client: HTTPClientSpy
	) {
		let client = HTTPClientSpy()
		let sut = RapidAPIHTTPClient(
			client: client,
			apiHost: apiHost,
			apiKey: apiKey
		)
		return (sut, client)
	}
}

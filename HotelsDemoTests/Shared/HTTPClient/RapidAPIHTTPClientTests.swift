//
//  RapidAPIHTTPClientTests.swift
//  HotelsDemoTests
//
//  Created by Denys Kotenko on 3/7/25.
//

import XCTest
import HotelsDemo

final class RapidAPIHTTPClientTests: XCTestCase {
	func test_perform_addsRapidAPIHeaders() {
		let (sut, client) = makeSUT(apiHost: "test-host", apiKey: "test-key")

		let dummyRequest = URLRequest(url: URL(string: "https://example.com")!)
		sut.perform(dummyRequest) { _ in }

		let headers = client.requests.first?.allHTTPHeaderFields
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

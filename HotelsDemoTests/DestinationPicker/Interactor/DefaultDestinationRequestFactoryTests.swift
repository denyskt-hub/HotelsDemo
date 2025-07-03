//
//  DefaultDestinationRequestFactoryTests.swift
//  HotelsDemoTests
//
//  Created by Denys Kotenko on 4/7/25.
//

import XCTest
import HotelsDemo

final class DefaultDestinationRequestFactoryTests: XCTestCase {
	func test_makeSearchRequest_buildsCorrectRequest() {
		let url = URL(string: "https://api.example.com/search")!
		let sut = makeSUT(url: url)

		let request = sut.makeSearchRequest(query: "paris")

		XCTAssertEqual(request.httpMethod, "GET")
		XCTAssertEqual(request.url?.scheme, "https")
		XCTAssertEqual(request.url?.host, "api.example.com")
		XCTAssertTrue(request.url?.query()?.contains("query=paris") ?? false)
	}

	func test_makeSearchRequest_encodesSpecialCharactersInQuery() {
		let url = URL(string: "https://api.example.com/search")!
		let sut = makeSUT(url: url)
		let query = "Café & Bar + Lounge?"
		let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .strictQueryValueAllowed)!

		let request = sut.makeSearchRequest(query: query)

		XCTAssertEqual(request.url?.query(percentEncoded: true), "query=\(encodedQuery)")
	}

	// MARK: - Helpers

	private func makeSUT(url: URL) -> DefaultDestinationRequestFactory {
		DefaultDestinationRequestFactory(url: url)
	}
}

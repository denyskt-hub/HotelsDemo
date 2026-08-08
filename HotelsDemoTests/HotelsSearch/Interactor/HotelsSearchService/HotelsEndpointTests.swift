//
//  HotelsEndpointTests.swift
//  HotelsDemoTests
//
//  Created by Denys Kotenko on 18/7/25.
//

import XCTest
import HotelsDemo

final class HotelsEndpointTests: XCTestCase {
	func test_hotels_endpointURL() {
		let baseURL = URL(string: "http://base-url.com")!

		let received = HotelsEndpoint.searchHotels.url(baseURL)

		XCTAssertEqual(received.scheme, "http", "scheme")
		XCTAssertEqual(received.host, "base-url.com", "host")
		XCTAssertEqual(received.path, "/api/v1/hotels/searchHotels", "path")
	}

	func test_hotels_endpointURL_appendsToBasePath() {
		let baseURL = URL(string: "https://base-url.com:8443/v2")!

		let received = HotelsEndpoint.searchHotels.url(baseURL)

		XCTAssertEqual(received.absoluteString, "https://base-url.com:8443/v2/api/v1/hotels/searchHotels")
	}

	func test_hotels_endpointURL_doesNotDoubleSeparatorOnTrailingSlash() {
		let baseURL = URL(string: "https://base-url.com/")!

		let received = HotelsEndpoint.searchHotels.url(baseURL)

		XCTAssertEqual(received.path, "/api/v1/hotels/searchHotels", "A trailing slash must not produce `//`")
	}
}

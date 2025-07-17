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
}

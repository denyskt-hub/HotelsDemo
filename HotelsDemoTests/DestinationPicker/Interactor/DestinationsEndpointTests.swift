//
//  DestinationsEndpointTests.swift
//  HotelsDemoTests
//
//  Created by Denys Kotenko on 4/7/25.
//

import XCTest
import HotelsDemo

final class DestinationsEndpointTests: XCTestCase {
	func test_destinations_endpointURL() {
		let baseURL = URL(string: "http://base-url.com")!

		let received = DestinationsEndpoint.searchDestination.url(baseURL)

		XCTAssertEqual(received.scheme, "http", "scheme")
		XCTAssertEqual(received.host, "base-url.com", "host")
		XCTAssertEqual(received.path, "/api/v1/hotels/searchDestination", "path")
	}
}

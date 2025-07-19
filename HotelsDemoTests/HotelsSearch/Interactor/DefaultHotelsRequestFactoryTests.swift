//
//  DefaultHotelsRequestFactoryTests.swift
//  HotelsDemoTests
//
//  Created by Denys Kotenko on 18/7/25.
//

import XCTest
import HotelsDemo

final class DefaultHotelsRequestFactoryTests: XCTestCase {
	func test_makeSearchRequest_buildsCorrectRequest() {
		let url = URL(string: "https://api.example.com/search")!
		let criteria = makeSearchCriteria(
			destination: makeDestination(
				id: 1,
				type: "city"
			),
			checkInDate: "18.07.2025".date(),
			checkOutDate: "19.07.2025".date(),
			adults: 2,
			childrenAge: [5,7],
			roomsQuantity: 1
		)
		let sut = makeSUT(url: url)

		let request = sut.makeSearchRequest(criteria: criteria)
		let requestURL = request.url
		let requestQuery = request.url?.query()

		XCTAssertEqual(request.httpMethod, "GET")
		XCTAssertEqual(requestURL?.scheme, "https")
		XCTAssertEqual(requestURL?.host, "api.example.com")

		XCTAssertEqual(requestQuery?.contains("dest_id=1"), true)
		XCTAssertEqual(requestQuery?.contains("search_type=city"), true)
		XCTAssertEqual(requestQuery?.contains("arrival_date=2025-07-18"), true)
		XCTAssertEqual(requestQuery?.contains("departure_date=2025-07-19"), true)
		XCTAssertEqual(requestQuery?.contains("adults=2"), true)
		XCTAssertEqual(requestQuery?.contains("children_age=5%2C7"), true) // children_age is a comma-separated list that gets percent-encoded ("," → "%2C")
		XCTAssertEqual(requestQuery?.contains("room_qty=1"), true)
	}

	// MARK: - Helpers

	private func makeSUT(url: URL) -> DefaultHotelsRequestFactory {
		DefaultHotelsRequestFactory(url: url)
	}
}

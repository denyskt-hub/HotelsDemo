//
//  DefaultSearchCriteriaProviderTests.swift
//  HotelsDemoTests
//
//  Created by Denys Kotenko on 26/6/25.
//

import XCTest
import HotelsDemo

final class DefaultSearchCriteriaProviderTests: XCTestCase {
	func test_retrieve_deliversDefaultSearchCriteria() {
		let currentDate = "26.06.2025".date()
		let defaultCriteria = SearchCriteria(
			destination: nil,
			checkInDate: "27.06.2025".date(),
			checkOutDate: "28.06.2025".date(),
			adults: 2,
			childrenAge: [],
			roomsQuantity: 1
		)
		let sut = makeSUT(calendar: .gregorian(), currentDate: { currentDate })

		let exp = expectation(description: "Wait for completion")

		sut.retrieve { result in
			switch result {
			case let .success(criteria):
				XCTAssertEqual(criteria, defaultCriteria)
			case let .failure(error):
				XCTFail("Expected success, got \(error) instead")
			}
			exp.fulfill()
		}

		wait(for: [exp], timeout: 1.0)
	}

	// MARK: - Helpers

	private func makeSUT(
		calendar: Calendar,
		currentDate: @escaping () -> Date
	) -> DefaultSearchCriteriaProvider {
		DefaultSearchCriteriaProvider(
			calendar: calendar,
			currentDate: currentDate
		)
	}
}

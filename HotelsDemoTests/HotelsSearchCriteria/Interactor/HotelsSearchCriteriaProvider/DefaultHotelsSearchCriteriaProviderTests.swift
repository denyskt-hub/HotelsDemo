//
//  DefaultSearchCriteriaProviderTests.swift
//  HotelsDemoTests
//
//  Created by Denys Kotenko on 26/6/25.
//

import XCTest
import HotelsDemo

final class DefaultHotelsSearchCriteriaProviderTests: XCTestCase {
	func test_retrieve_deliversDefaultSearchCriteria() {
		let currentDate = "26.06.2025".date()
		let expectedCriteria = HotelsSearchCriteriaDefaults.make(
			calendar: .gregorian(),
			currentDate: { currentDate }
		)
		let sut = makeSUT(calendar: .gregorian(), currentDate: { currentDate })

		let exp = expectation(description: "Wait for completion")

		sut.retrieve { result in
			switch result {
			case let .success(criteria):
				XCTAssertEqual(criteria, expectedCriteria)
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
	) -> DefaultHotelsSearchCriteriaProvider {
		DefaultHotelsSearchCriteriaProvider(
			calendar: calendar,
			currentDate: currentDate
		)
	}
}

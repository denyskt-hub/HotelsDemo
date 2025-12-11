//
//  DefaultSearchCriteriaProviderTests.swift
//  HotelsDemoTests
//
//  Created by Denys Kotenko on 26/6/25.
//

import XCTest
import HotelsDemo

@MainActor
final class DefaultHotelsSearchCriteriaProviderTests: XCTestCase {
	func test_retrieve_deliversDefaultSearchCriteria() async throws {
		let currentDate = "26.06.2025".date()
		let expectedCriteria = HotelsSearchCriteriaDefaults.make(
			calendar: .gregorian(),
			currentDate: { currentDate }
		)
		let sut = makeSUT(calendar: .gregorian(), currentDate: currentDate)

		let criteria = try await sut.retrieve()
		XCTAssertEqual(criteria, expectedCriteria)
	}

	// MARK: - Helpers

	private func makeSUT(
		calendar: Calendar,
		currentDate: Date
	) -> DefaultHotelsSearchCriteriaProvider {
		DefaultHotelsSearchCriteriaProvider(
			calendar: calendar,
			currentDate: { currentDate }
		)
	}
}

//
//  DefaultSearchCriteriaValidatorTests.swift
//  HotelsDemoTests
//
//  Created by Denys Kotenko on 26/6/25.
//

import XCTest
import HotelsDemo

final class DefaultSearchCriteriaValidatorTests: XCTestCase {
	func test_validate_returnsSameCriteria_whenAllIsValid() {
		let currentDate = "26.06.2025".date()
		let calendar = Calendar.gregorian()
		let validCriteria = makeValidSearchCriteria(
			calendar: calendar,
			currentDate: currentDate
		)
		let sut = makeSUT(calendar: calendar, currentDate: { currentDate })

		let result = sut.validate(validCriteria)

		XCTAssertEqual(result, validCriteria)
	}

	func test_validate_fixesInvalidDateCombinations() {
		let currentDate = "26.06.2025".date()
		let calendar = Calendar.gregorian()
		let cases: [(name: String, invalid: SearchCriteria, expected: SearchCriteria)] = [
			(
				name: "check-in before today",
				invalid: make(in: "25.06.2025", out: "27.06.2025"),
				expected: make(in: "27.06.2025", out: "28.06.2025")
			),
			(
				name: "check-out before check-in",
				invalid: make(in: "27.06.2025", out: "26.06.2025"),
				expected: make(in: "27.06.2025", out: "28.06.2025")
			),
			(
				name: "check-in equals check-out",
				invalid: make(in: "27.06.2025", out: "27.06.2025"),
				expected: make(in: "27.06.2025", out: "28.06.2025")
			)
		]

		let sut = makeSUT(calendar: calendar, currentDate: { currentDate })

		for testCase in cases {
			let result = sut.validate(testCase.invalid)

			XCTAssertEqual(result, testCase.expected, "Failed: \(testCase.name)")
		}
	}

	// MARK: - Helpers

	private func makeSUT(
		calendar: Calendar,
		currentDate: @escaping () -> Date
	) -> DefaultSearchCriteriaValidator {
		DefaultSearchCriteriaValidator(
			calendar: calendar,
			currentDate: currentDate
		)
	}

	private func make(in checkInDate: String, out checkOutDate: String) -> SearchCriteria {
		makeSearchCriteria(
			checkInDate: checkInDate.date(),
			checkOutDate: checkOutDate.date()
		)
	}

	private func makeValidSearchCriteria(
		calendar: Calendar,
		currentDate: Date
	) -> SearchCriteria {
		makeSearchCriteria(
			checkInDate: currentDate,
			checkOutDate: currentDate.adding(days: 1, calendar: calendar)
		)
	}

	private func makeSearchCriteria(
		checkInDate: Date,
		checkOutDate: Date
	) -> SearchCriteria {
		SearchCriteria(
			destination: nil,
			checkInDate: checkInDate,
			checkOutDate: checkOutDate,
			adults: 2,
			childrenAge: [],
			roomsQuantity: 1
		)
	}
}

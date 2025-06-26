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
		let invalidCriterias: [(invalid: SearchCriteria, expected: SearchCriteria)] = [
			(
				invalid: make(in: "25.06.2025", out: "27.06.2025"),
				expected: make(in: "27.06.2025", out: "28.06.2025")
			),
			(
				invalid: make(in: "27.06.2025", out: "26.06.2025"),
				expected: make(in: "27.06.2025", out: "28.06.2025")
			),
			(
				invalid: make(in: "27.06.2025", out: "27.06.2025"),
				expected: make(in: "27.06.2025", out: "28.06.2025")
			)
		]

		let sut = makeSUT(calendar: calendar, currentDate: { currentDate })

		for (inputCriteria, expectedCriteria) in invalidCriterias {
			let result = sut.validate(inputCriteria)

			XCTAssertEqual(result, expectedCriteria, "Failed for input: \(inputCriteria)")
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

extension String {
	func date(
		format: String = "dd.MM.yyyy",
		timeZone: TimeZone = TimeZone(secondsFromGMT: 0)!,
		locale: Locale = Locale(identifier: "en_US_POSIX")
	) -> Date {
		let formatter = DateFormatter()
		formatter.dateFormat = format
		formatter.timeZone = timeZone
		formatter.locale = locale
		return formatter.date(from: self)!
	}
}

extension Calendar {
	static func gregorian(
		timeZone: TimeZone = TimeZone(secondsFromGMT: 0)!,
		locale: Locale = Locale(identifier: "en_US_POSIX")
	) -> Calendar {
		var calendar = Calendar(identifier: .gregorian)
		calendar.timeZone = timeZone
		calendar.locale = locale
		return calendar
	}
}

//
//  DefaultHotelsSearchCriteriaValidatorTests.swift
//  HotelsDemoTests
//
//  Created by Denys Kotenko on 26/6/25.
//

import XCTest
import HotelsDemo

final class DefaultHotelsSearchCriteriaValidatorTests: XCTestCase {
	private enum TestDates {
		static let current = "26.06.2025".date()
		static let past = "25.06.2025".date()
		static let oneDayBeforePast = "24.06.2025".date()
		static let future = "27.06.2025".date()
		static let oneDayAfterFuture = "28.06.2025".date()
		static let twoDaysAfterFuture = "29.06.2025".date()
		static let furtherFuture = "05.07.2025".date()
	}

	func test_validate_returnsSameCriteria_whenAllIsValid() {
		let currentDate = TestDates.current
		let calendar = Calendar.gregorian()
		let validCriteria = makeValidSearchCriteria(
			calendar: calendar,
			currentDate: currentDate
		)
		let sut = makeSUT(calendar: calendar, currentDate: { currentDate })

		let result = sut.validate(validCriteria)

		XCTAssertEqual(result, validCriteria)
	}

	// MARK: - Dates Tests

	func test_validate_doesNotFixesValidDateCombinations() {
		let currentDate = TestDates.current
		let calendar = Calendar.gregorian()
		let validCriterias = [
			make(in: TestDates.future, out: TestDates.oneDayAfterFuture),
			make(in: TestDates.future, out: TestDates.twoDaysAfterFuture),
			make(in: TestDates.future, out: TestDates.furtherFuture)
		]
		let sut = makeSUT(calendar: calendar, currentDate: { currentDate })

		for valid in validCriterias {
			let result = sut.validate(valid)

			XCTAssertEqual(result, valid)
		}
	}

	func test_validate_fixesInvalidDateCombinations() {
		let currentDate = TestDates.current
		let calendar = Calendar.gregorian()
		let cases: [(name: String, invalid: HotelsSearchCriteria, expected: HotelsSearchCriteria)] = [
			(
				name: "check-in and check-out before today",
				invalid: make(in: TestDates.oneDayBeforePast, out: TestDates.past),
				expected: make(in: TestDates.future, out: TestDates.oneDayAfterFuture)
			),
			(
				name: "check-in before today",
				invalid: make(in: TestDates.past, out: TestDates.future),
				expected: make(in: TestDates.future, out: TestDates.oneDayAfterFuture)
			),
			(
				name: "check-in after check-out",
				invalid: make(in: TestDates.oneDayAfterFuture, out: TestDates.future),
				expected: make(in: TestDates.oneDayAfterFuture, out: TestDates.twoDaysAfterFuture)
			),
			(
				name: "check-in equals check-out",
				invalid: make(in: TestDates.future, out: TestDates.future),
				expected: make(in: TestDates.future, out: TestDates.oneDayAfterFuture)
			)
		]
		let sut = makeSUT(calendar: calendar, currentDate: { currentDate })

		for testCase in cases {
			let result = sut.validate(testCase.invalid)

			XCTAssertEqual(result, testCase.expected, "Failed: \(testCase.name)")
		}
	}

	// MARK: - Adults Tests

	func test_validate_doesNotFixesValidAdults() {
		let currentDate = TestDates.current
		let calendar = Calendar.gregorian()
		let validCriterias = makeValidAdultCriterias(calendar: calendar, currentDate: currentDate)
		let sut = makeSUT(calendar: calendar, currentDate: { currentDate })

		for valid in validCriterias {
			let result = sut.validate(valid)

			XCTAssertEqual(result, valid, "Expected valid criteria with \(valid.adults) adults to remain unchanged after validation")
		}
	}

	func test_validate_fixesInvalidAdults() {
		let currentDate = TestDates.current
		let calendar = Calendar.gregorian()
		let cases: [(name: String, invalid: HotelsSearchCriteria, expected: HotelsSearchCriteria)] = [
			(
				name: "adults less then min valid adults",
				invalid: make(calendar: calendar, currentDate: currentDate, adults: 0),
				expected: make(calendar: calendar, currentDate: currentDate, adults: 1)
			),
			(
				name: "adults greather then max valid adults",
				invalid: make(calendar: calendar, currentDate: currentDate, adults: 31),
				expected: make(calendar: calendar, currentDate: currentDate, adults: 30)
			)
		]
		let sut = makeSUT(calendar: calendar, currentDate: { currentDate })

		for testCase in cases {
			let result = sut.validate(testCase.invalid)

			XCTAssertEqual(result, testCase.expected, "Failed: \(testCase.name)")
		}
	}

	// MARK: - Children Age Tests

	func test_validate_doesNotFixesValidChildrenAge() {
		let currentDate = TestDates.current
		let calendar = Calendar.gregorian()
		let validCriterias = makeValidChildrenAgeCriterias(calendar: calendar, currentDate: currentDate)
		let sut = makeSUT(calendar: calendar, currentDate: { currentDate })

		for valid in validCriterias {
			let result = sut.validate(valid)

			XCTAssertEqual(result, valid, "Expected valid criteria with \(valid.childrenAge) childrenAge to remain unchanged after validation")
		}
	}

	func test_validate_fixesInvalidChildrenAges() {
		let currentDate = TestDates.current
		let calendar = Calendar.gregorian()
		let cases: [(name: String, invalid: HotelsSearchCriteria, expected: HotelsSearchCriteria)] = [
			(
				name: "child age below minimum",
				invalid: make(calendar: calendar, currentDate: currentDate, childrenAge: [-1]),
				expected: make(calendar: calendar, currentDate: currentDate, childrenAge: [0])
			),
			(
				name: "child age above maximum",
				invalid: make(calendar: calendar, currentDate: currentDate, childrenAge: [18]),
				expected: make(calendar: calendar, currentDate: currentDate, childrenAge: [17])
			)
		]
		let sut = makeSUT(calendar: calendar, currentDate: { currentDate })

		for testCase in cases {
			let result = sut.validate(testCase.invalid)

			XCTAssertEqual(result, testCase.expected, "Failed: \(testCase.name)")
		}
	}

	// MARK: - Rooms Tests

	func test_validate_doesNotFixesValidRooms() {
		let currentDate = TestDates.current
		let calendar = Calendar.gregorian()
		let validCriterias = makeValidRoomCriterias(calendar: calendar, currentDate: currentDate)
		let sut = makeSUT(calendar: calendar, currentDate: { currentDate })

		for valid in validCriterias {
			let result = sut.validate(valid)

			XCTAssertEqual(result, valid, "Expected valid criteria with \(valid.roomsQuantity) rooms to remain unchanged after validation")
		}
	}

	func test_validate_fixesInvalidRooms() {
		let currentDate = TestDates.current
		let calendar = Calendar.gregorian()
		let cases: [(name: String, invalid: HotelsSearchCriteria, expected: HotelsSearchCriteria)] = [
			(
				name: "rooms less then min valid rooms",
				invalid: make(calendar: calendar, currentDate: currentDate, rooms: 0),
				expected: make(calendar: calendar, currentDate: currentDate, rooms: 1)
			),
			(
				name: "rooms greather then max valid rooms",
				invalid: make(calendar: calendar, currentDate: currentDate, rooms: 31),
				expected: make(calendar: calendar, currentDate: currentDate, rooms: 30)
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
	) -> DefaultHotelsSearchCriteriaValidator {
		DefaultHotelsSearchCriteriaValidator(
			calendar: calendar,
			currentDate: currentDate
		)
	}

	private func make(in checkInDate: Date, out checkOutDate: Date) -> HotelsSearchCriteria {
		makeSearchCriteria(
			checkInDate: checkInDate,
			checkOutDate: checkOutDate
		)
	}

	private func make(calendar: Calendar, currentDate: Date, adults: Int) -> HotelsSearchCriteria {
		var searchCriteria = makeValidSearchCriteria(calendar: calendar, currentDate: currentDate)
		searchCriteria.adults = adults
		return searchCriteria
	}

	private func make(calendar: Calendar, currentDate: Date, childrenAge: [Int]) -> HotelsSearchCriteria {
		var searchCriteria = makeValidSearchCriteria(calendar: calendar, currentDate: currentDate)
		searchCriteria.childrenAge = childrenAge
		return searchCriteria
	}

	private func make(calendar: Calendar, currentDate: Date, rooms: Int) -> HotelsSearchCriteria {
		var searchCriteria = makeValidSearchCriteria(calendar: calendar, currentDate: currentDate)
		searchCriteria.roomsQuantity = rooms
		return searchCriteria
	}

	private func makeValidAdultCriterias(calendar: Calendar, currentDate: Date) -> [HotelsSearchCriteria] {
		(1...30).map { make(calendar: calendar, currentDate: currentDate, adults: $0) }
	}

	private func makeValidChildrenAgeCriterias(calendar: Calendar, currentDate: Date) -> [HotelsSearchCriteria] {
		(0...17).map { make(calendar: calendar, currentDate: currentDate, childrenAge: [$0]) }
	}

	private func makeValidRoomCriterias(calendar: Calendar, currentDate: Date) -> [HotelsSearchCriteria] {
		(1...30).map { make(calendar: calendar, currentDate: currentDate, rooms: $0) }
	}
}

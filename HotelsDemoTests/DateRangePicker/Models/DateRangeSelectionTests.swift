//
//  DateRangeSelectionTests.swift
//  HotelsDemoTests
//
//  Created by Denys Kotenko on 29/6/25.
//

import XCTest
import HotelsDemo

final class DateRangeSelectionTests: XCTestCase {
	func test_selectingFirstDate_setsStartDateOnly() {
		let selected = "01.07.2025".date()

		let result = DateRangeSelection().selecting(selected)

		XCTAssertEqual(result.startDate, selected)
		XCTAssertNil(result.endDate)
	}

	func test_selectingEarlierDate_replacesStartDate() {
		let initial = "01.07.2025".date()
		let earlier = "30.06.2025".date()

		let selection = DateRangeSelection(startDate: initial)
		let result = selection.selecting(earlier)

		XCTAssertEqual(result.startDate, earlier)
		XCTAssertNil(result.endDate)
	}

	func test_selectingSameDate_resetsSelection() {
		let date = "01.07.2025".date()

		let selection = DateRangeSelection(startDate: date)
		let result = selection.selecting(date)

		XCTAssertNil(result.startDate)
		XCTAssertNil(result.endDate)
	}

	func test_selectingLaterDate_setsEndDate() {
		let start = "01.07.2025".date()
		let end = "03.07.2025".date()

		let selection = DateRangeSelection(startDate: start)
		let result = selection.selecting(end)

		XCTAssertEqual(result.startDate, start)
		XCTAssertEqual(result.endDate, end)
	}
}

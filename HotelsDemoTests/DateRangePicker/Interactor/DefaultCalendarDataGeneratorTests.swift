//
//  DefaultCalendarDataGeneratorTests.swift
//  HotelsDemoTests
//
//  Created by Denys Kotenko on 29/6/25.
//

import XCTest
import HotelsDemo

final class DefaultCalendarDataGeneratorTests: XCTestCase {
	func test_generate_returnsDataForMonthsCountStartingFromCurrentMonth() {
		let calendar = Calendar.gregorian()
		let today = "02.06.2025".date()
		let sut = makeSUT(monthsCount: 1, calendar: calendar, currentDate: { today })

		let data = sut.generate(selectedStartDate: nil, selectedEndDate: nil)
		XCTAssertEqual(data.sections.count, 1)

		let firstMonth = data.sections.first?.month
		XCTAssertEqual(firstMonth, today.firstDateOfMonth(calendar: calendar))
	}

	func test_generate_marksDaysBeforeTodayAsDisabled() {
		let today = "05.06.2025".date()
		let sut = makeSUT(currentDate: { today })

		let data = sut.generate(selectedStartDate: nil, selectedEndDate: nil)
		let disabledDates = data.sections.flatMap(\.dates).filter { !$0.isEnabled }

		XCTAssertTrue(disabledDates.allSatisfy { dateVM in
			guard let d = dateVM.date else { return false }
			return d < today
		})
	}

	func test_generate_marksTodayCorrectly() throws {
		let today = "02.06.2025".date()
		let sut = makeSUT(currentDate: { today })

		let data = sut.generate(selectedStartDate: nil, selectedEndDate: nil)

		let todayDate = try XCTUnwrap(
			data.sections
				.flatMap(\.dates)
				.first(where: { $0.date == today })
		)

		XCTAssertTrue(todayDate.isToday == true)
	}

	func test_generate_marksSelectedDates() {
		let calendar = Calendar.gregorian()
		let today = "01.06.2025".date()
		let startDate = "03.06.2025".date()
		let endDate = "05.06.2025".date()
		let sut = makeSUT(calendar: calendar, currentDate: { today })

		let data = sut.generate(selectedStartDate: startDate, selectedEndDate: endDate)

		let selected = data.sections.flatMap(\.dates).filter { $0.isSelected }
		let inRange = data.sections.flatMap(\.dates).filter { $0.isInRange }

		XCTAssertEqual(selected.map(\.date), [startDate, endDate])
		XCTAssertTrue(inRange.allSatisfy { dateVM in
			guard let d = dateVM.date else { return false }
			return d >= startDate && d <= endDate
		})
	}

	func test_generate_doesNotAddLeadingEmptyDaysWhenMonthStartsOnFirstDayOfWeek() {
		var calendar = Calendar.gregorian()
		calendar.firstWeekday = 1 // Sunday
		let today = "01.09.2024".date() // September 2024 starts on Sunday
		let sut = makeSUT(calendar: calendar, currentDate: { today })

		let data = sut.generate(selectedStartDate: nil, selectedEndDate: nil)

		let firstMonthDates = data.sections.first!.dates
		let leadingEmptyDays = firstMonthDates.prefix { $0.date == nil }

		XCTAssertTrue(leadingEmptyDays.isEmpty)
	}

	func test_generate_addsLeadingEmptyDaysWhenMonthDoesNotStartOnFirstDayOfWeek() {
		var calendar = Calendar.gregorian()
		calendar.firstWeekday = 1 // Sunday
		let today = "01.08.2024".date() // August 2024 starts on Thursday
		let sut = makeSUT(calendar: calendar, currentDate: { today })

		let data = sut.generate(selectedStartDate: nil, selectedEndDate: nil)

		let firstMonthDates = data.sections.first!.dates
		let leadingEmptyDays = firstMonthDates.prefix { $0.date == nil }

		XCTAssertEqual(leadingEmptyDays.count, 4)
	}

	// MARK: - Helperes

	private func makeSUT(
		monthsCount: Int = 1,
		calendar: Calendar = .gregorian(),
		currentDate: @escaping () -> Date
	) -> DefaultCalendarDataGenerator {
		DefaultCalendarDataGenerator(
			monthsCount: monthsCount,
			calendar: calendar,
			currentDate: currentDate
		)
	}
}

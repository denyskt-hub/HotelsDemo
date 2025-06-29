//
//  DataRangePickerPresenterTests.swift
//  HotelsDemoTests
//
//  Created by Denys Kotenko on 29/6/25.
//

import XCTest
import HotelsDemo

final class DataRangePickerPresenterTests: XCTestCase {
	func test_present_displaysCalendar() {
		let fixtures = CalendarFormattingFixtures(
			date: "01.06.2025".date(),
			dateTitle: "1",
			monthTitle: "June 2025",
			weekdays: ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
		)
		let calendarData = makeCalendarData(
			weekdays: fixtures.weekdays,
			sections: [makeCalendarMonth(date: fixtures.date)]
		)
		let expectedViewModel = DateRangePickerModels.Load.ViewModel(
			calendar: makeCalendarViewModel(fixtures)
		)

		let (sut, viewController) = makeSUT()

		sut.present(response: .init(calendar: calendarData))

		XCTAssertEqual(viewController.messages, [.display(expectedViewModel)])
	}
	
	// MARK: - Helpers

	private func makeSUT() -> (
		sut: DataRangePickerPresenter,
		viewController: DateRangePickerDisplayLogicSpy
	) {
		let viewController = DateRangePickerDisplayLogicSpy()
		let sut = DataRangePickerPresenter(
			dateFormatter: DefaultCalendarDateFormatter()
		)
		sut.viewController = viewController
		return (sut, viewController)
	}

	typealias CalendarFormattingFixtures = (
		date: Date,
		dateTitle: String,
		monthTitle: String,
		weekdays: [String]
	)

	private func makeCalendarViewModel(_ fixtures: CalendarFormattingFixtures) -> DateRangePickerModels.CalendarViewModel {
		.init(
			weekdays: fixtures.weekdays,
			sections: [
				.init(
					title: fixtures.monthTitle,
					dates: [
						.init(
							id: .date(fixtures.date),
							date: fixtures.date,
							title: fixtures.dateTitle
						)
					]
				)
			]
		)
	}
}

final class DateRangePickerDisplayLogicSpy: DateRangePickerDisplayLogic {
	enum Message: Equatable {
		case display(DateRangePickerModels.Load.ViewModel)
		case displaySelectDate(DateRangePickerModels.DateSelection.ViewModel)
		case displaySelectedDateRange(DateRangePickerModels.Select.ViewModel)
	}

	private(set) var messages = [Message]()

	func display(viewModel: DateRangePickerModels.Load.ViewModel) {
		messages.append(.display(viewModel))
	}
	
	func displaySelectDate(viewModel: DateRangePickerModels.DateSelection.ViewModel) {

	}
	
	func displaySelectedDateRange(viewModel: DateRangePickerModels.Select.ViewModel) {

	}
}

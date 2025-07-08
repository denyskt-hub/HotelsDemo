//
//  DataRangePickerPresenterTests.swift
//  HotelsDemoTests
//
//  Created by Denys Kotenko on 29/6/25.
//

import XCTest
import HotelsDemo

final class DataRangePickerPresenterTests: XCTestCase {
	private let fixtures = CalendarFormattingFixtures(
		date: "01.06.2025".date(),
		dateTitle: "1",
		monthTitle: "June 2025",
		weekdays: ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
	)

	func test_present_displaysCalendar() {
		let calendarData = makeCalendarData(
			weekdays: fixtures.weekdays,
			sections: [makeCalendarMonth(date: fixtures.date)]
		)
		let expectedViewModel = DateRangePickerModels.Load.ViewModel(
			calendar: makeCalendarViewModel(fixtures),
			isApplyEnabled: false
		)
		let (sut, viewController) = makeSUT()

		sut.present(response: .init(calendar: calendarData, canApply: false))

		XCTAssertEqual(viewController.messages, [.display(expectedViewModel)])
	}

	func test_presentSelectDate_displaysSelectedDate() {
		let calendarData = makeCalendarData(
			weekdays: fixtures.weekdays,
			sections: [makeCalendarMonth(date: fixtures.date)]
		)
		let expectedViewModel = DateRangePickerModels.DateSelection.ViewModel(
			calendar: makeCalendarViewModel(fixtures),
			isApplyEnabled: false
		)
		let (sut, viewController) = makeSUT()

		sut.presentSelectDate(response: .init(calendar: calendarData, canApply: false))

		XCTAssertEqual(viewController.messages, [.displaySelectDate(expectedViewModel)])
	}

	func test_presentSelectedDateRange_displaysSelectedDateRange() {
		let startDate = "29.06.2025".date()
		let endDate = "30.06.2025".date()
		let expectedViewModel = DateRangePickerModels.Select.ViewModel(
			startDate: startDate,
			endDate: endDate
		)
		let (sut, viewController) = makeSUT()

		sut.presentSelectedDateRange(response: .init(startDate: startDate, endDate: endDate))

		XCTAssertEqual(viewController.messages, [.displaySelectedDateRange(expectedViewModel)])
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

	private func makeCalendarViewModel(_ fixtures: CalendarFormattingFixtures) -> DateRangePickerModels.CalendarViewModel {
		.init(
			weekdays: fixtures.weekdays,
			sections: [
				.init(
					title: fixtures.monthTitle,
					dates: [
						.init(
							date: fixtures.date,
							title: fixtures.dateTitle
						)
					]
				)
			]
		)
	}

	private struct CalendarFormattingFixtures {
		let date: Date
		let dateTitle: String
		let monthTitle: String
		let weekdays: [String]

		init(
			date: Date,
			dateTitle: String,
			monthTitle: String,
			weekdays: [String]
		) {
			self.date = date
			self.dateTitle = dateTitle
			self.monthTitle = monthTitle
			self.weekdays = weekdays
		}
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
		messages.append(.displaySelectDate(viewModel))
	}
	
	func displaySelectedDateRange(viewModel: DateRangePickerModels.Select.ViewModel) {
		messages.append(.displaySelectedDateRange(viewModel))
	}
}

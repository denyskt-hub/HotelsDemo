//
//  DateRangePickerInteractorTests.swift
//  HotelsDemoTests
//
//  Created by Denys Kotenko on 29/6/25.
//

import XCTest
import HotelsDemo

final class DateRangePickerInteractorTests: XCTestCase {
	func test_doFetchCalendar_presentCalendarData() {
		let calendarData = anyCalendarData()
		let expectedResponse = DateRangePickerModels.FetchCalendar.Response(
			calendar: calendarData,
			canApply: true
		)
		let (sut, _, presenter) = makeSUT(stub: calendarData)

		sut.doFetchCalendar(request: .init())

		XCTAssertEqual(presenter.messages, [.present(expectedResponse)])
	}

	func test_handleDateSelection_presentSelectDate() {
		let calendarData = anyCalendarData()
		let expectedResponse = DateRangePickerModels.DateSelection.Response(
			calendar: calendarData,
			canApply: false
		)
		let (sut, _, presenter) = makeSUT(stub: calendarData)

		sut.handleDateSelection(request: .init(date: "29.06.2025".date()))

		XCTAssertEqual(presenter.messages, [.presentSelectDate(expectedResponse)])
	}

	func test_handleDateRangeSelection_presentSelectedDateRange() {
		let calendarData = anyCalendarData()
		let selectedStartDate = "29.06.2025".date()
		let selectedEndDate = "30.06.2025".date()
		let expectedResponse = DateRangePickerModels.DateRangeSelection.Response(
			startDate: selectedStartDate,
			endDate: selectedEndDate
		)
		let (sut, _, presenter) = makeSUT(
			stub: calendarData,
			selectedStartDate: selectedStartDate,
			selectedEndDate: selectedEndDate
		)

		sut.handleDateRangeSelection(request: .init())

		XCTAssertEqual(presenter.messages, [.presentSelectedDateRange(expectedResponse)])
	}

	// MARK: - Helpers

	private func makeSUT(
		stub: DateRangePickerModels.CalendarData,
		selectedStartDate: Date = .now,
		selectedEndDate: Date = .now
	) -> (
		sut: DateRangePickerInteractor,
		generator: CalendarDataGeneratorStub,
		presenter: DateRangePickerPresentationLogicSpy
	) {
		let generator = CalendarDataGeneratorStub(stub: stub)
		let presenter = DateRangePickerPresentationLogicSpy()
		let sut = DateRangePickerInteractor(
			selectedStartDate: selectedStartDate,
			selectedEndDate: selectedEndDate,
			generator: generator,
			presenter: presenter
		)
		return (sut, generator, presenter)
	}
}

final class CalendarDataGeneratorStub: CalendarDataGenerator {
	var stub: DateRangePickerModels.CalendarData

	init(stub: DateRangePickerModels.CalendarData) {
		self.stub = stub
	}
	
	func generate(selectedRange: SelectedDateRange) -> DateRangePickerModels.CalendarData {
		stub
	}
}

final class DateRangePickerPresentationLogicSpy: DateRangePickerPresentationLogic {
	enum Message: Equatable {
		case present(DateRangePickerModels.FetchCalendar.Response)
		case presentSelectDate(DateRangePickerModels.DateSelection.Response)
		case presentSelectedDateRange(DateRangePickerModels.DateRangeSelection.Response)
	}

	private(set) var messages = [Message]()

	func present(response: DateRangePickerModels.FetchCalendar.Response) {
		messages.append(.present(response))
	}

	func presentSelectDate(response: DateRangePickerModels.DateSelection.Response) {
		messages.append(.presentSelectDate(response))
	}

	func presentSelectedDateRange(response: DateRangePickerModels.DateRangeSelection.Response) {
		messages.append(.presentSelectedDateRange(response))
	}
}

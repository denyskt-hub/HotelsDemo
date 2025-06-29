//
//  DateRangePickerInteractorTests.swift
//  HotelsDemoTests
//
//  Created by Denys Kotenko on 29/6/25.
//

import XCTest
import HotelsDemo

final class DateRangePickerInteractorTests: XCTestCase {
	func test_load_presentCalendarData() {
		let expectedCalendarData = anyCalendarDate()
		let (sut, _, presenter) = makeSUT(stub: expectedCalendarData)

		sut.load(request: .init())

		XCTAssertEqual(presenter.messages, [.present(.init(calendar: expectedCalendarData))])
	}

	// MARK: - Helpers

	private func makeSUT(stub: DateRangePickerModels.CalendarData) -> (
		sut: DateRangePickerInteractor,
		generator: CalendarDataGeneratorStub,
		presenter: DateRangePickerPresentationLogicSpy
	) {
		let generator = CalendarDataGeneratorStub(stub: stub)
		let presenter = DateRangePickerPresentationLogicSpy()
		let sut = DateRangePickerInteractor(
			startDate: .now,
			endDate: .now,
			generator: generator
		)
		sut.presenter = presenter
		return (sut, generator, presenter)
	}

	private func anyCalendarDate() -> DateRangePickerModels.CalendarData {
		.init(
			weekdays: weekdays(),
			sections: [anyCalendarMonth()]
		)
	}

	private func weekdays() -> [String] {
		["S", "M", "T", "W", "T", "F", "S"]
	}

	private func anyCalendarMonth() -> DateRangePickerModels.CalendarMonth {
		.init(
			month: "01.06.2025".date(),
			dates: [.init(date: "01.06.2025".date())]
		)
	}
}

final class CalendarDataGeneratorStub: CalendarDataGenerator {
	var stub: DateRangePickerModels.CalendarData

	init(stub: DateRangePickerModels.CalendarData) {
		self.stub = stub
	}

	func generate(
		selectedStartDate: Date? = nil,
		selectedEndDate: Date? = nil
	) -> DateRangePickerModels.CalendarData {
		stub
	}
}

final class DateRangePickerPresentationLogicSpy: DateRangePickerPresentationLogic {
	enum Message: Equatable {
		case present(DateRangePickerModels.Load.Response)
	}

	private(set) var messages = [Message]()

	func present(response: DateRangePickerModels.Load.Response) {
		messages.append(.present(response))
	}

	func presentSelectDate(response: DateRangePickerModels.DateSelection.Response) {

	}

	func presentSelectedDateRange(response: DateRangePickerModels.Select.Response) {

	}
}

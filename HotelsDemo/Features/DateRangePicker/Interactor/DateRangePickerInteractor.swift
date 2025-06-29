//
//  DateRangePickerInteractor.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 22/6/25.
//

import Foundation

public final class DateRangePickerInteractor: DateRangePickerBusinessLogic {
	private var dateRangeSelection: DateRangeSelection
	private let generator: CalendarDataGenerator

	public var presenter: DateRangePickerPresentationLogic?

	public init(
		startDate: Date,
		endDate: Date,
		generator: CalendarDataGenerator
	) {
		self.dateRangeSelection = DateRangeSelection(startDate: startDate, endDate: endDate)
		self.generator = generator
	}

	public func load(request: DateRangePickerModels.Load.Request) {
		presenter?.present(
			response: DateRangePickerModels.Load.Response(
				calendar: makeCalendarData()
			)
		)
	}

	public func didSelectDate(request: DateRangePickerModels.DateSelection.Request) {
		dateRangeSelection = dateRangeSelection.selecting(request.date)

		presenter?.presentSelectDate(
			response: DateRangePickerModels.DateSelection.Response(
				calendar: makeCalendarData(),
				canApply: dateRangeSelection.canApply
			)
		)
	}

	public func selectDateRange(request: DateRangePickerModels.Select.Request) {
		guard let startDate = dateRangeSelection.startDate,
			  let endDate = dateRangeSelection.endDate else {
			preconditionFailure("Can't select date range without start and end date")
		}

		presenter?.presentSelectedDateRange(
			response: DateRangePickerModels.Select.Response(
				startDate: startDate,
				endDate: endDate
			)
		)
	}

	private func makeCalendarData() -> DateRangePickerModels.CalendarData {
		generator.generate(
			selectedStartDate: dateRangeSelection.startDate,
			selectedEndDate: dateRangeSelection.endDate
		)
	}
}

struct DateRangeSelection {
	let startDate: Date?
	let endDate: Date?

	init(startDate: Date? = nil, endDate: Date? = nil) {
		self.startDate = startDate
		self.endDate = endDate
	}

	func selecting(_ selectedDate: Date) -> DateRangeSelection {
		switch (startDate, endDate) {
		case let (start?, nil) where selectedDate < start:
			return DateRangeSelection(startDate: selectedDate, endDate: nil)

		case let (start?, nil) where selectedDate == start:
			return DateRangeSelection(startDate: nil, endDate: nil)

		case let (start?, nil) where selectedDate > start:
			return DateRangeSelection(startDate: start, endDate: selectedDate)

		default:
			return DateRangeSelection(startDate: selectedDate, endDate: nil)
		}
	}
}

extension DateRangeSelection {
	var canApply: Bool {
		startDate != nil && endDate != nil
	}
}

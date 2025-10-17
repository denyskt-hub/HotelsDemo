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
	private let presenter: DateRangePickerPresentationLogic

	public init(
		selectedStartDate: Date,
		selectedEndDate: Date,
		generator: CalendarDataGenerator,
		presenter: DateRangePickerPresentationLogic
	) {
		self.dateRangeSelection = DateRangeSelection(
			startDate: selectedStartDate,
			endDate: selectedEndDate
		)
		self.generator = generator
		self.presenter = presenter
	}

	public func doFetchCalendar(request: DateRangePickerModels.FetchCalendar.Request) {
		presenter.present(
			response: DateRangePickerModels.FetchCalendar.Response(
				calendar: makeCalendarData(),
				canApply: dateRangeSelection.canApply
			)
		)
	}

	public func handleDateSelection(request: DateRangePickerModels.DateSelection.Request) {
		dateRangeSelection = dateRangeSelection.selecting(request.date)

		presenter.presentSelectDate(
			response: DateRangePickerModels.DateSelection.Response(
				calendar: makeCalendarData(),
				canApply: dateRangeSelection.canApply
			)
		)
	}

	public func handleDateRangeSelection(request: DateRangePickerModels.DateRangeSelection.Request) {
		guard let startDate = dateRangeSelection.startDate,
			  let endDate = dateRangeSelection.endDate else {
			preconditionFailure("Can't select date range without start and end date")
		}

		presenter.presentSelectedDateRange(
			response: DateRangePickerModels.DateRangeSelection.Response(
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

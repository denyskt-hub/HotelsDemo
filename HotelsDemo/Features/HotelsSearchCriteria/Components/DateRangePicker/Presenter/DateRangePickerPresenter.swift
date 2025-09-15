//
//  DateRangePickerPresentationLogic.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 22/6/25.
//

import Foundation

public final class DataRangePickerPresenter: DateRangePickerPresentationLogic {
	private let dateFormatter: CalendarDateFormatter

	public weak var viewController: DateRangePickerDisplayLogic?

	public init(dateFormatter: CalendarDateFormatter) {
		self.dateFormatter = dateFormatter
	}

	public func present(response: DateRangePickerModels.FetchCalendar.Response) {
		let viewModel = DateRangePickerModels.FetchCalendar.ViewModel(
			calendar: makeCalendarViewModel(response.calendar),
			isApplyEnabled: response.canApply
		)
		viewController?.display(viewModel: viewModel)
	}

	public func presentSelectDate(response: DateRangePickerModels.DateSelection.Response) {
		let viewModel = DateRangePickerModels.DateSelection.ViewModel(
			calendar: makeCalendarViewModel(response.calendar),
			isApplyEnabled: response.canApply
		)
		viewController?.displaySelectDate(viewModel: viewModel)
	}

	public func presentSelectedDateRange(response: DateRangePickerModels.DateRangeSelection.Response) {
		let viewModel = DateRangePickerModels.DateRangeSelection.ViewModel(
			startDate: response.startDate,
			endDate: response.endDate
		)
		viewController?.displaySelectedDateRange(viewModel: viewModel)
	}

	private func makeCalendarViewModel(
		_ calendar: DateRangePickerModels.CalendarData
	) -> DateRangePickerModels.CalendarViewModel {
		.init(
			weekdays: calendar.weekdays,
			sections: calendar.sections.map(makeCalendarMonthViewModel(section:))
		)
	}

	private func makeCalendarMonthViewModel(
		section: DateRangePickerModels.CalendarMonth
	) -> DateRangePickerModels.CalendarMonthViewModel {
		.init(
			title: dateFormatter.formatMonth(from: section.month),
			dates: section.dates.map(makeCalendarDateViewModel(date:))
		)
	}

	private func makeCalendarDateViewModel(
		date: DateRangePickerModels.CalendarDate
	) -> DateRangePickerModels.CalendarDateViewModel {
		.init(
			date: date.date,
			title: date.date.map(dateFormatter.formatDay),
			rangePosition: date.rangePosition,
			isToday: date.isToday,
			isEnabled: date.isEnabled,
			isSelected: date.isSelected,
			isInRange: date.isInRange
		)
	}
}

//
//  DateRangePickerInteractor.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 22/6/25.
//

import Foundation

public final class DateRangePickerInteractor: DateRangePickerBusinessLogic {
	private var dateRangeSelection: DateRangeSelection
	private let calendar: Calendar

	public var presenter: DateRangePickerPresentationLogic?

	public init(
		startDate: Date,
		endDate: Date,
		calendar: Calendar
	) {
		self.dateRangeSelection = DateRangeSelection(startDate: startDate, endDate: endDate)
		self.calendar = calendar
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
		.init(
			weekdays: calendar.weekdaySymbols,
			sections: generateSections(
				from: .now,
				selectedStartDate: dateRangeSelection.startDate,
				selectedEndDate: dateRangeSelection.endDate,
				calendar: calendar
			)
		)
	}

	private func generateSections(from date: Date, selectedStartDate: Date?, selectedEndDate: Date?, calendar: Calendar) -> [DateRangePickerModels.CalendarMonth] {
		let start = date.firstDateOfMonth(calendar: calendar)
		let end = start
			.adding(months: 12, calendar: calendar)
			.adding(days: -1, calendar: calendar)

		let months = monthsBetween(start: start, end: end, calendar: calendar)

		return months.map {
			DateRangePickerModels.CalendarMonth(
				month: $0,
				dates: allMonthDates(start: $0, selectedStartDate: selectedStartDate, selectedEndDate: selectedEndDate, calendar: calendar)
			)
		}
	}

	func monthsBetween(start: Date, end: Date, calendar: Calendar) -> [Date] {
		var result: [Date] = []
		var current = calendar.date(from: calendar.dateComponents([.year, .month], from: start))!

		while current <= end {
			result.append(current)
			current = current.adding(months: 1, calendar: calendar)
		}

		return result
	}

	func allMonthDates(start: Date, selectedStartDate: Date?, selectedEndDate: Date?, calendar: Calendar) -> [DateRangePickerModels.CalendarDate] {
		var result = [DateRangePickerModels.CalendarDate]()

		let weekday = calendar.component(.weekday, from: start)
		let leadingEmptyDays = weekday - 1
		result.append(contentsOf: Array(repeating: .init(date: nil), count: leadingEmptyDays))

		var current = start
		let end = start
			.adding(months: 1, calendar: calendar)
			.adding(days: -1, calendar: calendar)

		let now = calendar.startOfDay(for: .now)

		while current <= end {
			let isSelected = current == selectedStartDate || current == selectedEndDate
			let isInRange = isDateInSelectedRange(current, selectedStartDate, selectedEndDate)

			result.append(
				.init(
					date: current,
					isToday: current == now,
					isEnabled: current >= now,
					isSelected: isSelected,
					isInRange: isInRange
				)
			)
			current = current.adding(days: 1, calendar: calendar)
		}

		return result
	}

	private func isDateInSelectedRange(_ date: Date, _ start: Date?, _ end: Date?) -> Bool {
		guard let start = start, let end = end else {
			return false
		}

		return date >= start && date <= end
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

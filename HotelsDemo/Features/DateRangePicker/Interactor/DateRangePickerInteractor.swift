//
//  DateRangePickerInteractor.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 22/6/25.
//

import Foundation

public protocol DateRangePickerBusinessLogic {
	func load(request: DateRangePickerModels.Load.Request)
	func selectDate(request: DateRangePickerModels.Select.Request)
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

public final class DateRangePickerInteractor: DateRangePickerBusinessLogic {
	private let calendar: Calendar
	private var dateRangeSelection = DateRangeSelection()

	public var presenter: DateRangePickerPresentationLogic?

	public init(calendar: Calendar) {
		self.calendar = calendar
	}

	public func load(request: DateRangePickerModels.Load.Request) {
		presenter?.present(
			response: DateRangePickerModels.Load.Response(
				weekdays: calendar.weekdaySymbols,
				sections: generateSections(from: .now, selectedStartDate: nil, selectedEndDate: nil, calendar: calendar)
			)
		)
	}

	public func selectDate(request: DateRangePickerModels.Select.Request) {
		dateRangeSelection = dateRangeSelection.selecting(request.date)

		presenter?.presentSelectDate(
			response: DateRangePickerModels.Select.Response(
				weekdays: calendar.weekdaySymbols,
				sections: generateSections(
					from: .now,
					selectedStartDate: dateRangeSelection.startDate,
					selectedEndDate: dateRangeSelection.endDate,
					calendar: calendar
				)
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

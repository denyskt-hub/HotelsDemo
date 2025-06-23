//
//  DateRangePickerInteractor.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 22/6/25.
//

import Foundation

public protocol DateRangePickerBusinessLogic {
	func load(request: DateRangePickerModels.Load.Request)
}

public final class DateRangePickerInteractor: DateRangePickerBusinessLogic {
	private let calendar: Calendar

	public var presenter: DateRangePickerPresentationLogic?

	public init(calendar: Calendar) {
		self.calendar = calendar
	}

	public func load(request: DateRangePickerModels.Load.Request) {
		presenter?.display(
			response: DateRangePickerModels.Load.Response(
				weekdays: calendar.weekdaySymbols,
				sections: generateSections(from: .now, calendar: calendar)
			)
		)
	}

	private func generateSections(from date: Date, calendar: Calendar) -> [DateRangePickerModels.CalendarMonth] {
		let start = date.firstDateOfMonth(calendar: calendar)
		let end = start
			.adding(months: 12, calendar: calendar)
			.adding(days: -1, calendar: calendar)

		let months = monthsBetween(start: start, end: end, calendar: calendar)

		return months.map {
			DateRangePickerModels.CalendarMonth(
				month: $0,
				dates: allMonthDates(start: $0, calendar: calendar)
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

	func allMonthDates(start: Date, calendar: Calendar) -> [DateRangePickerModels.CalendarDate] {
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
			result.append(.init(date: current, isToday: current == now))
			current = current.adding(days: 1, calendar: calendar)
		}

		return result
	}
}

//
//  DefaultCalendarDataGenerator.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 29/6/25.
//

import Foundation

public final class DefaultCalendarDataGenerator: CalendarDataGenerator {
	private let monthsCount: Int
	private let calendar: Calendar
	private let currentDate: () -> Date

	public init(
		monthsCount: Int = 12,
		calendar: Calendar,
		currentDate: @escaping () -> Date
	) {
		self.monthsCount = monthsCount
		self.calendar = calendar
		self.currentDate = currentDate
	}

	public func generate(
		selectedStartDate: Date?,
		selectedEndDate: Date?
	) -> DateRangePickerModels.CalendarData {
		.init(
			weekdays: calendar.weekdaySymbols,
			sections: generateSections(
				monthsCount: monthsCount,
				currentDate: currentDate(),
				selectedStartDate: selectedStartDate,
				selectedEndDate: selectedEndDate,
				calendar: calendar
			)
		)
	}

	private func generateSections(
		monthsCount: Int,
		currentDate: Date,
		selectedStartDate: Date?,
		selectedEndDate: Date?,
		calendar: Calendar
	) -> [DateRangePickerModels.CalendarMonth] {
		let start = currentDate.firstDateOfMonth(calendar: calendar)
		let end = start
			.adding(months: monthsCount, calendar: calendar)
			.adding(days: -1, calendar: calendar)

		let months = monthsBetween(
			start: start,
			end: end,
			calendar: calendar
		)

		return months.map {
			DateRangePickerModels.CalendarMonth(
				month: $0,
				dates: allMonthDates(
					start: $0,
					currentDate: currentDate,
					selectedStartDate: selectedStartDate,
					selectedEndDate: selectedEndDate,
					calendar: calendar
				)
			)
		}
	}

	private func monthsBetween(
		start: Date,
		end: Date,
		calendar: Calendar
	) -> [Date] {
		var result: [Date] = []

		guard var current = calendar.date(from: calendar.dateComponents([.year, .month], from: start)) else {
			return result
		}

		while current <= end {
			result.append(current)
			current = current.adding(months: 1, calendar: calendar)
		}

		return result
	}

	private func allMonthDates(
		start: Date,
		currentDate: Date,
		selectedStartDate: Date?,
		selectedEndDate: Date?,
		calendar: Calendar
	) -> [DateRangePickerModels.CalendarDate] {
		var result = [DateRangePickerModels.CalendarDate]()

		let weekday = calendar.component(.weekday, from: start)
		let leadingEmptyDays = (weekday - calendar.firstWeekday + 7) % 7
		result.append(contentsOf: Array(repeating: .init(date: nil), count: leadingEmptyDays))

		var current = start
		let end = start
			.adding(months: 1, calendar: calendar)
			.adding(days: -1, calendar: calendar)

		let today = calendar.startOfDay(for: currentDate)

		while current <= end {
			var rangePosition = DateRangePosition.none
			if current == selectedStartDate && selectedEndDate == nil {
				rangePosition = .single
			} else if current == selectedStartDate && selectedEndDate != nil {
				rangePosition = .start
			} else if current == selectedEndDate {
				rangePosition = .end
			} else if isDateInSelectedRange(current, selectedStartDate, selectedEndDate) {
				rangePosition = .middle
			}

			result.append(
				.init(
					date: current,
					rangePosition: rangePosition,
					isToday: current == today,
					isEnabled: current >= today
				)
			)
			current = current.adding(days: 1, calendar: calendar)
		}

		return result
	}

	private func isDateInSelectedRange(
		_ date: Date,
		_ start: Date?,
		_ end: Date?
	) -> Bool {
		guard let start = start, let end = end else {
			return false
		}

		return date >= start && date <= end
	}
}

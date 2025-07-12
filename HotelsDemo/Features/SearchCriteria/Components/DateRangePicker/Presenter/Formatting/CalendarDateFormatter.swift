//
//  CalendarDateFormatter.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 25/6/25.
//

import Foundation

public protocol CalendarDateFormatter {
	func formatMonth(from date: Date) -> String
	func formatDay(from date: Date) -> String
}

public final class DefaultCalendarDateFormatter: CalendarDateFormatter {
	private let monthFormatter: DateFormatter
	private let dayFormatter: DateFormatter

	public init(calendar: Calendar = .current) {
		self.monthFormatter = DateFormatter()
		monthFormatter.dateFormat = "LLLL yyyy"
		monthFormatter.calendar = calendar
		monthFormatter.timeZone = calendar.timeZone

		self.dayFormatter = DateFormatter()
		dayFormatter.dateFormat = "d"
		dayFormatter.calendar = calendar
		dayFormatter.timeZone = calendar.timeZone
	}

	public func formatMonth(from date: Date) -> String {
		monthFormatter.string(from: date)
	}

	public func formatDay(from date: Date) -> String {
		dayFormatter.string(from: date)
	}
}

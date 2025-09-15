//
//  DateRangePickerModels.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 22/6/25.
//

import Foundation

public enum DateRangePickerModels {
	public enum FetchCalendar {
		public struct Request: Equatable {
			public init() {}
		}

		public struct Response: Equatable {
			public let calendar: CalendarData
			public let canApply: Bool

			public init(calendar: CalendarData, canApply: Bool) {
				self.calendar = calendar
				self.canApply = canApply
			}
		}

		public struct ViewModel: Equatable {
			public let calendar: CalendarViewModel
			public let isApplyEnabled: Bool

			public init(calendar: CalendarViewModel, isApplyEnabled: Bool) {
				self.calendar = calendar
				self.isApplyEnabled = isApplyEnabled
			}
		}
	}

	public enum DateSelection {
		public struct Request: Equatable {
			public let date: Date

			public init(date: Date) {
				self.date = date
			}
		}

		public struct Response: Equatable {
			public let calendar: CalendarData
			public let canApply: Bool

			public init(calendar: CalendarData, canApply: Bool) {
				self.calendar = calendar
				self.canApply = canApply
			}
		}

		public struct ViewModel: Equatable {
			public let calendar: CalendarViewModel
			public let isApplyEnabled: Bool

			public init(calendar: CalendarViewModel, isApplyEnabled: Bool) {
				self.calendar = calendar
				self.isApplyEnabled = isApplyEnabled
			}
		}
	}

	public enum DateRangeSelection {
		public struct Request: Equatable {
			public init() {}
		}

		public struct Response: Equatable {
			public let startDate: Date
			public let endDate: Date

			public init(startDate: Date, endDate: Date) {
				self.startDate = startDate
				self.endDate = endDate
			}
		}

		public struct ViewModel: Equatable {
			public let startDate: Date
			public let endDate: Date

			public init(startDate: Date, endDate: Date) {
				self.startDate = startDate
				self.endDate = endDate
			}
		}
	}

	public struct ViewModel: Equatable {
		public let startDate: Date
		public let endDate: Date

		public init(startDate: Date, endDate: Date) {
			self.startDate = startDate
			self.endDate = endDate
		}
	}

	public struct CalendarData: Equatable {
		public let weekdays: [String]
		public let sections: [CalendarMonth]

		public init(weekdays: [String], sections: [CalendarMonth]) {
			self.weekdays = weekdays
			self.sections = sections
		}
	}

	public struct CalendarMonth: Equatable {
		public let month: Date
		public let dates: [CalendarDate]

		public init(month: Date, dates: [CalendarDate]) {
			self.month = month
			self.dates = dates
		}
	}

	public struct CalendarDate: Equatable {
		public let date: Date?
		public let rangePosition: DateRangePosition
		public let isToday: Bool
		public let isEnabled: Bool
		public var isSelected: Bool {
			rangePosition == .start || rangePosition == .end || rangePosition == .single
		}
		public var isInRange: Bool {
			rangePosition == .middle
		}

		public init(
			date: Date?,
			rangePosition: DateRangePosition = .none,
			isToday: Bool = false,
			isEnabled: Bool = true
		) {
			self.date = date
			self.rangePosition = rangePosition
			self.isToday = isToday
			self.isEnabled = isEnabled
		}
	}

	public struct CalendarViewModel: Equatable {
		public let weekdays: [String]
		public let sections: [CalendarMonthViewModel]

		public init(weekdays: [String], sections: [CalendarMonthViewModel]) {
			self.weekdays = weekdays
			self.sections = sections
		}
	}

	public struct CalendarMonthViewModel: Equatable {
		public let title: String
		public let dates: [CalendarDateViewModel]

		public init(title: String, dates: [CalendarDateViewModel]) {
			self.title = title
			self.dates = dates
		}
	}

	public struct CalendarDateViewModel: Equatable {
		public let date: Date?
		public let title: String?
		public let rangePosition: DateRangePosition
		public let isToday: Bool
		public let isEnabled: Bool
		public let isSelected: Bool
		public let isInRange: Bool

		public init(
			date: Date?,
			title: String?,
			rangePosition: DateRangePosition = .none,
			isToday: Bool = false,
			isEnabled: Bool = true,
			isSelected: Bool = false,
			isInRange: Bool = false
		) {
			self.date = date
			self.title = title
			self.rangePosition = rangePosition
			self.isToday = isToday
			self.isEnabled = isEnabled
			self.isSelected = isSelected
			self.isInRange = isInRange
		}
	}
}

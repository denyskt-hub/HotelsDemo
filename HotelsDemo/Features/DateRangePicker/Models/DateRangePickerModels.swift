//
//  DateRangePickerModels.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 22/6/25.
//

import Foundation

public enum DateRangePickerModels {
	public enum Load {
		public struct Request {
			public init() {}
		}

		public struct Response: Equatable {
			public let calendar: CalendarData

			public init(calendar: CalendarData) {
				self.calendar = calendar
			}
		}

		public struct ViewModel: Equatable {
			public let calendar: CalendarViewModel

			public init(calendar: CalendarViewModel) {
				self.calendar = calendar
			}
		}
	}

	public enum DateSelection {
		public struct Request {
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

	public enum Select {
		public struct Request {
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
		public let isToday: Bool
		public let isEnabled: Bool
		public let isSelected: Bool
		public let isInRange: Bool

		public init(
			date: Date?,
			isToday: Bool = false,
			isEnabled: Bool = true,
			isSelected: Bool = false,
			isInRange: Bool = false
		) {
			self.date = date
			self.isToday = isToday
			self.isEnabled = isEnabled
			self.isSelected = isSelected
			self.isInRange = isInRange
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

	public enum CalendarDateID: Hashable {
		case date(Date)
		case placeholder(UUID)
	}

	public struct CalendarDateViewModel {
		public let id: CalendarDateID
		public let date: Date?
		public let title: String?
		public let isToday: Bool
		public let isEnabled: Bool
		public let isSelected: Bool
		public let isInRange: Bool

		public init(
			id: CalendarDateID,
			date: Date?,
			title: String?,
			isToday: Bool = false,
			isEnabled: Bool = true,
			isSelected: Bool = false,
			isInRange: Bool = false
		) {
			self.id = id
			self.date = date
			self.title = title
			self.isToday = isToday
			self.isEnabled = isEnabled
			self.isSelected = isSelected
			self.isInRange = isInRange
		}
	}
}

extension DateRangePickerModels.CalendarMonthViewModel: Hashable {
	public func hash(into hasher: inout Hasher) {
		hasher.combine(title)
	}
}

extension DateRangePickerModels.CalendarDateViewModel: Equatable {
	public static func == (lhs: DateRangePickerModels.CalendarDateViewModel, rhs: DateRangePickerModels.CalendarDateViewModel) -> Bool {
		lhs.id == rhs.id
	}
}

extension DateRangePickerModels.CalendarDateViewModel: Hashable {
	public func hash(into hasher: inout Hasher) {
		hasher.combine(id)
	}
}

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

		public struct ViewModel {
			public let calendar: CalendarViewModel

			public init(calendar: CalendarViewModel) {
				self.calendar = calendar
			}
		}
	}

	public enum DateSelection {
		public struct Request {
			let date: Date
		}

		public struct Response {
			let calendar: CalendarData
			let canApply: Bool
		}

		public struct ViewModel {
			let calendar: CalendarViewModel
			let isApplyEnabled: Bool
		}
	}

	public enum Select {
		public struct Request {}

		public struct Response {
			let startDate: Date
			let endDate: Date
		}

		public struct ViewModel {
			let startDate: Date
			let endDate: Date
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

	public struct CalendarViewModel {
		let weekdays: [String]
		let sections: [CalendarMonthViewModel]
	}

	public struct CalendarMonthViewModel {
		let title: String
		let dates: [CalendarDateViewModel]
	}

	public enum CalendarDateID: Hashable{
		case date(Date)
		case placeholder(UUID)
	}

	public struct CalendarDateViewModel {
		let id: CalendarDateID
		let date: Date?
		let title: String?
		let isToday: Bool
		let isEnabled: Bool
		let isSelected: Bool
		let isInRange: Bool
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

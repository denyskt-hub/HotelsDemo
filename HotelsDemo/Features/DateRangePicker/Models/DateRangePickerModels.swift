//
//  DateRangePickerModels.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 22/6/25.
//

import Foundation

public enum DateRangePickerModels {
	public enum Load {
		public struct Request {}

		public struct Response {
			let weekdays: [String]
			let sections: [CalendarMonth]
		}

		public struct ViewModel {
			let weekdays: [String]
			let sections: [CalendarMonthViewModel]
		}
	}

	public struct CalendarMonth {
		let month: Date
		let dates: [CalendarDate]
	}

	public struct CalendarDate {
		let date: Date?
		let isToday: Bool

		init(date: Date?, isToday: Bool = false) {
			self.date = date
			self.isToday = isToday
		}
	}

	public struct CalendarMonthViewModel {
		let title: String
		let dates: [CalendarDateViewModel]
	}

	public struct CalendarDateViewModel {
		let date: String?
		let isToday: Bool
	}
}

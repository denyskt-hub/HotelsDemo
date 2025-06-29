//
//  SharedTestHelpers.swift
//  HotelsDemoTests
//
//  Created by Denys Kotenko on 29/6/25.
//

import Foundation
import HotelsDemo

func weekdays() -> [String] {
	["S", "M", "T", "W", "T", "F", "S"]
}

func anyCalendarData() -> DateRangePickerModels.CalendarData {
	.init(
		weekdays: weekdays(),
		sections: [anyCalendarMonth()]
	)
}

func anyCalendarMonth() -> DateRangePickerModels.CalendarMonth {
	.init(
		month: "01.06.2025".date(),
		dates: [.init(date: "01.06.2025".date())]
	)
}

func makeCalendarData(
	weekdays: [String],
	sections: [DateRangePickerModels.CalendarMonth] = []
) -> DateRangePickerModels.CalendarData {
	.init(
		weekdays: weekdays,
		sections: sections
	)
}

func makeCalendarMonth(date: Date) -> DateRangePickerModels.CalendarMonth {
	.init(
		month: date,
		dates: [.init(date: date)]
	)
}

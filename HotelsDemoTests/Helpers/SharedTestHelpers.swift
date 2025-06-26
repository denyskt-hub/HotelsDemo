//
//  SharedTestHelpers.swift
//  HotelsDemoTests
//
//  Created by Denys Kotenko on 26/6/25.
//

import Foundation
import HotelsDemo

func anySearchCriteria() -> SearchCriteria {
	SearchCriteria(
		destination: nil,
		checkInDate: .now,
		checkOutDate: .now,
		adults: 2,
		childrenAge: [],
		roomsQuantity: 1
	)
}

func makeValidSearchCriteria(
	calendar: Calendar,
	currentDate: Date
) -> SearchCriteria {
	makeSearchCriteria(
		checkInDate: currentDate,
		checkOutDate: currentDate.adding(days: 1, calendar: calendar)
	)
}

func makeSearchCriteria(
	checkInDate: Date,
	checkOutDate: Date
) -> SearchCriteria {
	SearchCriteria(
		destination: nil,
		checkInDate: checkInDate,
		checkOutDate: checkOutDate,
		adults: 2,
		childrenAge: [],
		roomsQuantity: 1
	)
}

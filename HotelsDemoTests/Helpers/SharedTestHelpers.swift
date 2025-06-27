//
//  SharedTestHelpers.swift
//  HotelsDemoTests
//
//  Created by Denys Kotenko on 26/6/25.
//

import Foundation
import HotelsDemo

func anyNSError() -> NSError {
	NSError(domain: "any", code: 1)
}

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

func anyDestination() -> Destination {
	Destination(
		id: 1,
		type: "country",
		name: "any",
		label: "any label",
		country: "any",
		cityName: "any"
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
	destination: Destination? = nil,
	checkInDate: Date,
	checkOutDate: Date,
	adults: Int = 2,
	childrenAge: [Int] = [],
	roomsQuantity: Int = 1
) -> SearchCriteria {
	SearchCriteria(
		destination: destination,
		checkInDate: checkInDate,
		checkOutDate: checkOutDate,
		adults: adults,
		childrenAge: childrenAge,
		roomsQuantity: roomsQuantity
	)
}

func makeDestination(label: String) -> Destination {
	Destination(
		id: 1,
		type: "country",
		name: "any",
		label: label,
		country: "any",
		cityName: "any"
	)
}

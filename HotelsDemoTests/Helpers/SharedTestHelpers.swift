//
//  SharedTestHelpers.swift
//  HotelsDemoTests
//
//  Created by Denys Kotenko on 26/6/25.
//

import Foundation
import HotelsDemo

func anyURL() -> URL {
	URL(string: "https://any.com")!
}

func anyNSError() -> NSError {
	NSError(domain: "any", code: 1)
}

func anyData() -> Data {
	Data("any".utf8)
}

func emptyData() -> Data {
	Data()
}

func invalidJSONData() -> Data {
	Data("inalid json".utf8)
}

func anyHTTPURLResponse() -> HTTPURLResponse {
	HTTPURLResponse(url: URL(string: "https://any.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
}

func makeHTTPURLResponse(statusCode: Int) -> HTTPURLResponse {
	HTTPURLResponse(url: URL(string: "https://any.com")!, statusCode: statusCode, httpVersion: nil, headerFields: nil)!
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

func makeDestination(
	name: String = "any name",
	label: String = "any label",
	country: String = "any country",
	cityName: String = "any city name"
) -> Destination {
	Destination(
		id: 1,
		type: "country",
		name: name,
		label: label,
		country: country,
		cityName: cityName
	)
}

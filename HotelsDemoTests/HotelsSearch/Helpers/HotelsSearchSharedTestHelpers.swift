//
//  HotelsSearchSharedTestHelpers.swift
//  HotelsDemoTests
//
//  Created by Denys Kotenko on 17/7/25.
//

import Foundation
import HotelsDemo

func anyHotel() -> Hotel {
	Hotel(
		id: 1,
		position: 0,
		name: "Hotel",
		starRating: 3,
		reviewCount: 5,
		reviewScore: 9.0,
		photoURLs: [anyURL()],
		price: Price(
			grossPrice: 100,
			currency: "USD"
		)
	)
}

func makeHotel(
	id: Int = 0,
	position: Int = 0,
	name: String = "Hotel",
	starRating: Int = 5,
	reviewCount: Int = 0,
	reviewScore: Decimal = 0,
	photoURLs: [URL] = [],
	grossPrice: Decimal = 100,
	currency: String = "USD"
) -> Hotel {
	Hotel(
		id: id,
		position: position,
		name: name,
		starRating: starRating,
		reviewCount: reviewCount,
		reviewScore: reviewScore,
		photoURLs: photoURLs,
		price: Price(
			grossPrice: grossPrice,
			currency: currency
		)
	)
}

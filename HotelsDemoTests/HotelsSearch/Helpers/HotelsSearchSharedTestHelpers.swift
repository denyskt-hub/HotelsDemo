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
	id: Int,
	position: Int,
	name: String,
	starRating: Int,
	reviewCount: Int,
	reviewScore: Decimal,
	photoURLs: [URL],
	grossPrice: Decimal,
	currency: String
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

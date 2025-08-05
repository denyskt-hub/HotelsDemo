//
//  HotelStarRatingSpecificationTests.swift
//  HotelsDemoTests
//
//  Created by Denys Kotenko on 5/8/25.
//

import XCTest
import HotelsDemo

final class HotelStarRatingSpecificationTests: XCTestCase {
	func test_isSatisfiedBy_deliversTrueOnHotelMatches() {
		let sut = HotelStarRatingSpecification(allowedRatings: [StarRating.four.rawValue, StarRating.five.rawValue])

		var hotel = makeHotel(starRating: StarRating.four.rawValue)
		XCTAssertTrue(sut.isSatisfied(by: hotel))

		hotel = makeHotel(starRating: StarRating.five.rawValue)
		XCTAssertTrue(sut.isSatisfied(by: hotel))
	}

	func test_isSatisfiedBy_deliversFalseOnHotelDoesNotMatch() {
		let hotel = makeHotel(starRating: StarRating.two.rawValue)
		let sut = HotelStarRatingSpecification(allowedRatings: [StarRating.one.rawValue])

		XCTAssertFalse(sut.isSatisfied(by: hotel))
	}
}

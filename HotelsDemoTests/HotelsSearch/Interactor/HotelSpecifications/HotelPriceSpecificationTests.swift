//
//  HotelPriceSpecificationTests.swift
//  HotelsDemoTests
//
//  Created by Denys Kotenko on 5/8/25.
//

import XCTest
import HotelsDemo

final class HotelPriceSpecificationTests: XCTestCase {
	func test_isSatisfiedBy_deliversTrueOnHotelMatches() {
		let hotel = makeHotel(grossPrice: 100)
		let sut = HotelPriceSpecification(priceRange: 90...110)

		XCTAssertTrue(sut.isSatisfied(by: hotel))
	}

	func test_isSatisfiedBy_deliversFalseOnHotelDoesNotMatch() {
		let hotel = makeHotel(grossPrice: 200)
		let sut = HotelPriceSpecification(priceRange: 90...110)

		XCTAssertFalse(sut.isSatisfied(by: hotel))
	}
}

//
//  HotelReviewScoreSpecificationTests.swift
//  HotelsDemoTests
//
//  Created by Denys Kotenko on 5/8/25.
//

import XCTest
import HotelsDemo

final class HotelReviewScoreSpecificationTests: XCTestCase {
	func test_isSatisfiedBy_deliversTrueOnHotelMatches() {
		let sut = HotelReviewScoreSpecification(reviewScore: ReviewScore.veryGood.rawValue)

		var hotel = makeHotel(reviewScore: ReviewScore.veryGood.rawValue)
		XCTAssertTrue(sut.isSatisfied(by: hotel))

		hotel = makeHotel(reviewScore: ReviewScore.wonderful.rawValue)
		XCTAssertTrue(sut.isSatisfied(by: hotel))
	}

	func test_isSatisfiedBy_deliversFalseOnHotelDoesNotMatch() {
		let hotel = makeHotel(reviewScore: ReviewScore.good.rawValue)
		let sut = HotelReviewScoreSpecification(reviewScore: ReviewScore.veryGood.rawValue)

		XCTAssertFalse(sut.isSatisfied(by: hotel))
	}
}

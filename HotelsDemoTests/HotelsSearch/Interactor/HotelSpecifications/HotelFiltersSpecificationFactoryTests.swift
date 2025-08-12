//
//  HotelFiltersSpecificationFactoryTests.swift
//  HotelsDemoTests
//
//  Created by Denys Kotenko on 12/8/25.
//

import XCTest
import HotelsDemo

final class HotelFiltersSpecificationFactoryTests: XCTestCase {
	func test_make_withEmptyFiltersAllowsAnyHotel() {
		let filters = HotelFilters(priceRange: nil, starRatings: [], reviewScore: nil)
		let sut = makeSUT(filters: filters)

		XCTAssertTrue(sut.isSatisfied(by: makeHotel(starRating: 5, reviewScore: 10, grossPrice: 50)))
		XCTAssertTrue(sut.isSatisfied(by: makeHotel(starRating: 3, reviewCount: 4, grossPrice: 23)))
	}

	func test_make_withPriceFilterOnlyMatchesWithinRange() {
		let filters = HotelFilters(priceRange: 100...200, starRatings: [], reviewScore: nil)
		let sut = makeSUT(filters: filters)

		XCTAssertTrue(sut.isSatisfied(by: makeHotel(grossPrice: 150)), "Should accept price within range")
		XCTAssertTrue(sut.isSatisfied(by: makeHotel(grossPrice: 100)), "Should accept price at lower bound")
		XCTAssertTrue(sut.isSatisfied(by: makeHotel(grossPrice: 200)), "Should accept price at upper bound")
		XCTAssertFalse(sut.isSatisfied(by: makeHotel(grossPrice: 99)), "Should reject price below range")
		XCTAssertFalse(sut.isSatisfied(by: makeHotel(grossPrice: 201)), "Should reject price above range")
	}

	func test_make_withStarRatingsOnlyMatchesAllowedRatings() {
		let filters = HotelFilters(priceRange: nil, starRatings: [.three, .five], reviewScore: nil)
		let sut = makeSUT(filters: filters)

		XCTAssertTrue(sut.isSatisfied(by: makeHotel(starRating: 3)), "Should accept rating 3")
		XCTAssertTrue(sut.isSatisfied(by: makeHotel(starRating: 5)), "Should accept rating 5")
		XCTAssertFalse(sut.isSatisfied(by: makeHotel(starRating: 4)), "Should reject rating not in allowed list")
	}

	func test_make_withReviewScoreOnlyMatchesHotelsAboveThreshold() {
		let filters = HotelFilters(priceRange: nil, starRatings: [], reviewScore: .veryGood)
		let sut = makeSUT(filters: filters)

		XCTAssertTrue(sut.isSatisfied(by: makeHotel(reviewScore: ReviewScore.veryGood.rawValue)), "Should accept score equal to threshold")
		XCTAssertTrue(sut.isSatisfied(by: makeHotel(reviewScore: ReviewScore.wonderful.rawValue)), "Should accept score above threshold")
		XCTAssertFalse(sut.isSatisfied(by: makeHotel(reviewScore: ReviewScore.fair.rawValue)), "Should reject score below threshold")
	}

	func test_make_withMultipleFiltersRequiresAllToMatch() {
		let filters = HotelFilters(priceRange: 100...200, starRatings: [.four], reviewScore: .veryGood)
		let sut = makeSUT(filters: filters)

		XCTAssertTrue(sut.isSatisfied(by: makeHotel(starRating: 4, reviewScore: ReviewScore.veryGood.rawValue, grossPrice: 150)), "All filters match")
		XCTAssertFalse(sut.isSatisfied(by: makeHotel(starRating: 3, reviewScore: ReviewScore.veryGood.rawValue, grossPrice: 150)), "Star rating fails")
		XCTAssertFalse(sut.isSatisfied(by: makeHotel(starRating: 4, reviewScore: ReviewScore.veryGood.rawValue, grossPrice: 250)), "Price fails")
		XCTAssertFalse(sut.isSatisfied(by: makeHotel(starRating: 4, reviewScore: ReviewScore.good.rawValue, grossPrice: 150)), "Review score fails")
	}

	// MARK: - Helpers

	private func makeSUT(filters: HotelFilters) -> any HotelSpecification {
		HotelFiltersSpecificationFactory.make(from: filters)
	}
}

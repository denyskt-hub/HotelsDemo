//
//  DefaultHotelsRepositoryTests.swift
//  HotelsDemoTests
//
//  Created by Denys Kotenko on 5/8/25.
//

import XCTest
import HotelsDemo

final class DefaultHotelsRepositoryTests: XCTestCase {
	func test_allHotels_deliversHotels() {
		let sut = makeSUT()
		XCTAssertTrue(sut.allHotels().isEmpty)

		var hotels = [Hotel]()
		sut.setHotels(hotels)
		XCTAssertTrue(sut.allHotels().isEmpty)

		hotels = [anyHotel(), anyHotel()]
		sut.setHotels(hotels)
		XCTAssertEqual(sut.allHotels(), hotels)

	}

	func test_setHotels_overridesPreviousHotels() {
		let oldHotel = makeHotel(id: 1, name: "old")
		let newHotel = makeHotel(id: 2, name: "new")
		let sut = makeSUT(hotels: [oldHotel])

		sut.setHotels([newHotel])

		XCTAssertEqual(sut.allHotels(), [newHotel])
	}

	func test_filterWithStarRatingSpecification_deliversMatchingHotels() {
		let hotel1 = makeHotel(id: 1, starRating: StarRating.five.rawValue)
		let hotel2 = makeHotel(id: 2, starRating: StarRating.four.rawValue)
		let sut = makeSUT(hotels: [hotel1, hotel2])

		let spec = HotelStarRatingSpecification(allowedRatings: [StarRating.five.rawValue])
		let result = sut.filter(with: spec)

		XCTAssertEqual(result, [hotel1])
	}

	func test_filterWithReviewScoreSpecification_deliversMatchingHotels() {
		let hotel1 = makeHotel(id: 1, reviewScore: ReviewScore.good.rawValue)
		let hotel2 = makeHotel(id: 2, reviewScore: ReviewScore.fair.rawValue)
		let sut = makeSUT(hotels: [hotel1, hotel2])

		let spec = HotelReviewScoreSpecification(reviewScore: ReviewScore.good.rawValue)
		let result = sut.filter(with: spec)

		XCTAssertEqual(result, [hotel1])
	}

	// MARK: - Helpers

	private func makeSUT(hotels: [Hotel] = []) -> DefaultHotelsRepository {
		DefaultHotelsRepository(hotels: hotels)
	}
}

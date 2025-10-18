//
//  HotelFiltersPickerInteractorTests.swift
//  HotelsDemoTests
//
//  Created by Denys Kotenko on 27/7/25.
//

import XCTest
import HotelsDemo

final class HotelFiltersPickerInteractorTests: XCTestCase {
	func test_doFetchFilters_presentsFilters() {
		let filters = anyHotelFilters()
		let (sut, presenter) = makeSUT(currentFilters: filters)

		sut.doFetchFilters(request: .init())

		XCTAssertEqual(presenter.messages, [
			.present(.init(filters: filters))
		])
	}

	func test_handleFilterSelection_presentsSelectedFilters() {
		let (sut, presenter) = makeSUT(currentFilters: anyHotelFilters())

		sut.handleFilterSelection(request: .init())

		XCTAssertEqual(presenter.messages, [
			.presentSelectedFilters(.init(filters: anyHotelFilters()))
		])
	}

	func test_handleFilterReset_presentsResetFilters() {
		let (sut, presenter) = makeSUT(currentFilters: nonEmptyHotelFilters())

		sut.handleFilterReset(request: .init())

		XCTAssertEqual(presenter.messages, [
			.present(.init(filters: emptyHotelFilters())),
			.presentResetFilters(.init())
		])
	}

	func test_handleFilterReset_resetsCurrentFilters() {
		let emptyFilters = emptyHotelFilters()
		let currentFilters = HotelFilters(
			priceRange: 0...100,
			starRatings: Set([.five]),
			reviewScore: .wonderful
		)
		let (sut, presenter) = makeSUT(currentFilters: currentFilters)

		sut.handleFilterReset(request: .init())
		sut.handleFilterSelection(request: .init())

		XCTAssertEqual(presenter.messages, [
			.present(.init(filters: emptyFilters)),
			.presentResetFilters(.init()),
			.presentSelectedFilters(.init(filters: emptyFilters))
		])
	}

	func test_handlePriceRangeSelection_updatesCurrentFilters() {
		let (sut, presenter) = makeSUT(currentFilters: HotelFilters())

		sut.handlePriceRangeSelection(request: .init(priceRange: 10...20))
		sut.handleFilterSelection(request: .init())

		XCTAssertEqual(presenter.messages, [
			.present(.init(filters: HotelFilters(priceRange: 10...20))),
			.presentSelectedFilters(.init(filters: HotelFilters(priceRange: 10...20)))
		])
	}

	func test_handleStarRatingSelection_updatesCurrentFilters() {
		let (sut, presenter) = makeSUT(currentFilters: HotelFilters())

		sut.handleStarRatingSelection(request: .init(starRatings: [.five]))
		sut.handleFilterSelection(request: .init())

		XCTAssertEqual(presenter.messages, [
			.present(.init(filters: HotelFilters(starRatings: [.five]))),
			.presentSelectedFilters(.init(filters: HotelFilters(starRatings: [.five])))
		])
	}

	func test_handleReviewScoreSelection_updatesCurrentFilters() {
		let (sut, presenter) = makeSUT(currentFilters: HotelFilters())

		sut.handleReviewScoreSelection(request: .init(reviewScore: .wonderful))
		sut.handleFilterSelection(request: .init())

		XCTAssertEqual(presenter.messages, [
			.present(.init(filters: HotelFilters(reviewScore: .wonderful))),
			.presentSelectedFilters(.init(filters: HotelFilters(reviewScore: .wonderful)))
		])
	}

	// MARK: - Helpers

	private func makeSUT(currentFilters: HotelFilters) -> (
		sut: HotelFiltersPickerInteractor,
		presenter: HotelFiltersPickerPresentationLogicSpy
	) {
		let presenter = HotelFiltersPickerPresentationLogicSpy()
		let sut = HotelFiltersPickerInteractor(
			currentFilters: currentFilters,
			presenter: presenter
		)
		return (sut, presenter)
	}
}

final class HotelFiltersPickerPresentationLogicSpy: HotelFiltersPickerPresentationLogic {
	enum Message: Equatable {
		case present(HotelFiltersPickerModels.FetchFilters.Response)
		case presentSelectedFilters(HotelFiltersPickerModels.FilterSelection.Response)
		case presentResetFilters(HotelFiltersPickerModels.FilterReset.Response)
	}

	private(set) var messages = [Message]()

	func present(response: HotelFiltersPickerModels.FetchFilters.Response) {
		messages.append(.present(response))
	}

	func presentSelectedFilters(response: HotelFiltersPickerModels.FilterSelection.Response) {
		messages.append(.presentSelectedFilters(response))
	}
	
	func presentResetFilters(response: HotelFiltersPickerModels.FilterReset.Response) {
		messages.append(.presentResetFilters(response))
	}
}

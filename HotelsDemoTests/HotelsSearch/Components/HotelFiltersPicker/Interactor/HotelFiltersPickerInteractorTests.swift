//
//  HotelFiltersPickerInteractorTests.swift
//  HotelsDemoTests
//
//  Created by Denys Kotenko on 27/7/25.
//

import XCTest
import HotelsDemo

final class HotelFiltersPickerInteractorTests: XCTestCase {
	func test_load_presentsFilters() {
		let filters = anyHotelFilters()
		let (sut, presenter) = makeSUT(currentFilters: filters)

		sut.load(request: .init())

		XCTAssertEqual(presenter.messages, [
			.present(.init(filters: filters))
		])
	}

	func test_selectFilters_presentsSelectedFilters() {
		let (sut, presenter) = makeSUT(currentFilters: anyHotelFilters())

		sut.selectFilters(request: .init())

		XCTAssertEqual(presenter.messages, [
			.presentSelectedFilters(.init(filters: anyHotelFilters()))
		])
	}

	func test_resetFilters_presentsResetFilters() {
		let (sut, presenter) = makeSUT(currentFilters: nonEmptyHotelFilters())

		sut.resetFilters(request: .init())

		XCTAssertEqual(presenter.messages, [
			.present(.init(filters: emptyHotelFilters())),
			.presentResetFilters(.init())
		])
	}

	func test_resetFilters_resetsCurrentFilters() {
		let emptyFilters = emptyHotelFilters()
		let currentFilters = HotelFilters(
			priceRange: 0...100,
			starRatings: Set([.five]),
			reviewScore: .wonderful
		)
		let (sut, presenter) = makeSUT(currentFilters: currentFilters)

		sut.resetFilters(request: .init())
		sut.selectFilters(request: .init())

		XCTAssertEqual(presenter.messages, [
			.present(.init(filters: emptyFilters)),
			.presentResetFilters(.init()),
			.presentSelectedFilters(.init(filters: emptyFilters))
		])
	}

	func test_updatePriceRange_updatesCurrentFilters() {
		let (sut, presenter) = makeSUT(currentFilters: HotelFilters())

		sut.updatePriceRange(request: .init(priceRange: 10...20))
		sut.selectFilters(request: .init())

		XCTAssertEqual(presenter.messages, [
			.present(.init(filters: HotelFilters(priceRange: 10...20))),
			.presentSelectedFilters(.init(filters: HotelFilters(priceRange: 10...20)))
		])
	}

	func test_updateStarRatings_updatesCurrentFilters() {
		let (sut, presenter) = makeSUT(currentFilters: HotelFilters())

		sut.updateStarRatings(request: .init(starRatings: [.five]))
		sut.selectFilters(request: .init())

		XCTAssertEqual(presenter.messages, [
			.present(.init(filters: HotelFilters(starRatings: [.five]))),
			.presentSelectedFilters(.init(filters: HotelFilters(starRatings: [.five])))
		])
	}

	func test_updateReviewScore_updatesCurrentFilters() {
		let (sut, presenter) = makeSUT(currentFilters: HotelFilters())

		sut.updateReviewScore(request: .init(reviewScore: .wonderful))
		sut.selectFilters(request: .init())

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
		let sut = HotelFiltersPickerInteractor(currentFilters: currentFilters)
		sut.presenter = presenter
		return (sut, presenter)
	}
}

final class HotelFiltersPickerPresentationLogicSpy: HotelFiltersPickerPresentationLogic {
	enum Message: Equatable {
		case present(HotelFiltersPickerModels.Load.Response)
		case presentSelectedFilters(HotelFiltersPickerModels.Select.Response)
		case presentResetFilters(HotelFiltersPickerModels.Reset.Response)
	}

	private(set) var messages = [Message]()

	func present(response: HotelFiltersPickerModels.Load.Response) {
		messages.append(.present(response))
	}

	func presentSelectedFilters(response: HotelFiltersPickerModels.Select.Response) {
		messages.append(.presentSelectedFilters(response))
	}
	
	func presentResetFilters(response: HotelFiltersPickerModels.Reset.Response) {
		messages.append(.presentResetFilters(response))
	}
}

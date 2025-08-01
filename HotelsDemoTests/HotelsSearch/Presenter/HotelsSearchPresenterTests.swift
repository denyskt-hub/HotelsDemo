//
//  HotelsSearchPresenterTests.swift
//  HotelsDemoTests
//
//  Created by Denys Kotenko on 17/7/25.
//

import XCTest
import HotelsDemo

final class HotelsSearchPresenterTests: XCTestCase {
	func test_presentSearch_displaysSearch() {
		let photoURL = URL(string: "https://example.com/photo")!
		let hotels = [
			makeHotel(
				id: 1,
				position: 0,
				name: "Hotel",
				starRating: 4,
				reviewCount: 93,
				reviewScore: 9.5,
				photoURLs: [photoURL],
				grossPrice: 150.0,
				currency: "USD"
			)
		]
		let (sut, viewController) = makeSUT()

		sut.presentSearch(response: .init(hotels: hotels))

		XCTAssertEqual(viewController.messages, [
			.displaySearch(
				.init(hotels: [
					.init(
						position: 0,
						starRating: 4,
						name: "Hotel",
						score: "9.5",
						reviews: "93 reviews",
						price: "$150.00",
						priceDetails: "Includes taxes and fees",
						photoURL: photoURL
					)
				])
			)
		])
	}

	func test_presentSearchError_displaysSearchError() {
		let error = TestError("error message")
		let (sut, viewController) = makeSUT()

		sut.presentSearchError(error)

		XCTAssertEqual(viewController.messages, [.displaySearchError(.init(message: "error message"))])
	}

	// MARK: - Helpers

	private func makeSUT(locale: Locale = Locale(identifier: "en_US")) -> (
		sut: HotelsSearchPresenter,
		viewController: SearchDisplayLogicSpy
	) {
		let viewController = SearchDisplayLogicSpy()
		let sut = HotelsSearchPresenter(priceFormatter: PriceFormatter(locale: locale))
		sut.viewController = viewController
		return (sut, viewController)
	}
}

final class SearchDisplayLogicSpy: HotelsSearchDisplayLogic {
	enum Message: Equatable {
		case displaySearch(HotelsSearchModels.Search.ViewModel)
		case displayLoading(HotelsSearchModels.LoadingViewModel)
		case displaySearchError(HotelsSearchModels.ErrorViewModel)
		case displayFilter(HotelsSearchModels.Filter.ViewModel)
		case displayUpdateFilter(HotelsSearchModels.UpdateFilter.ViewModel)
	}

	private(set) var messages = [Message]()

	func displaySearch(viewModel: HotelsSearchModels.Search.ViewModel) {
		messages.append(.displaySearch(viewModel))
	}

	func displayLoading(viewModel: HotelsSearchModels.LoadingViewModel) {
		messages.append(.displayLoading(viewModel))
	}

	func displaySearchError(viewModel: HotelsSearchModels.ErrorViewModel) {
		messages.append(.displaySearchError(viewModel))
	}

	func displayFilter(viewModel: HotelsSearchModels.Filter.ViewModel) {
		messages.append(.displayFilter(viewModel))
	}

	func displayUpdateFilter(viewModel: HotelsSearchModels.UpdateFilter.ViewModel) {
		messages.append(.displayUpdateFilter(viewModel))
	}
}

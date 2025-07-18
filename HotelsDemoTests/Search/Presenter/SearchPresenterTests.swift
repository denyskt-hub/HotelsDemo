//
//  SearchPresenterTests.swift
//  HotelsDemoTests
//
//  Created by Denys Kotenko on 17/7/25.
//

import XCTest
import HotelsDemo

final class SearchPresenterTests: XCTestCase {
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
						price: "US$150.00",
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

	private func makeSUT() -> (
		sut: SearchPresenter,
		viewController: SearchDisplayLogicSpy
	) {
		let viewController = SearchDisplayLogicSpy()
		let sut = SearchPresenter()
		sut.viewController = viewController
		return (sut, viewController)
	}
}

final class SearchDisplayLogicSpy: SearchDisplayLogic {
	enum Message: Equatable {
		case displaySearch(SearchModels.Search.ViewModel)
		case displaySearchError(SearchModels.ErrorViewModel)
	}

	private(set) var messages = [Message]()

	func displaySearch(viewModel: SearchModels.Search.ViewModel) {
		messages.append(.displaySearch(viewModel))
	}
	
	func displaySearchError(viewModel: SearchModels.ErrorViewModel) {
		messages.append(.displaySearchError(viewModel))
	}
}

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

	func test_presentFilters_displaysFilters() {
		let filters = anyHotelFilters()
		let (sut, viewController) = makeSUT()

		sut.presentFilters(response: .init(filters: filters))

		XCTAssertEqual(viewController.messages, [.displayFilters(.init(filters: filters))])
	}

	func test_presentSearchLoading_displaysLoading() {
		let (sut, viewController) = makeSUT()

		sut.presentSearchLoading(true)
		XCTAssertEqual(viewController.messages.last, .displayLoading(.init(isLoading: true)))

		sut.presentSearchLoading(false)
		XCTAssertEqual(viewController.messages.last, .displayLoading(.init(isLoading: false)))
	}

	func test_presentUpdateFilters_displaysUpdateFilters() {
		let (sut, viewController) = makeSUT()

		sut.presentUpdateFilters(response: .init(hotels: []))

		XCTAssertEqual(viewController.messages, [.displayUpdateFilters(.init(hotels: []))])
	}

	// MARK: - Helpers

	private func makeSUT(locale: Locale = Locale(identifier: "en_US")) -> (
		sut: HotelsSearchPresenter,
		viewController: SearchDisplayLogicSpy
	) {
		let viewController = SearchDisplayLogicSpy()
		let sut = HotelsSearchPresenter(
			priceFormatter: PriceFormatter(locale: locale),
			viewController: viewController
		)
		return (sut, viewController)
	}
}

final class SearchDisplayLogicSpy: HotelsSearchDisplayLogic {
	enum Message: Equatable {
		case displaySearch(HotelsSearchModels.Search.ViewModel)
		case displayLoading(HotelsSearchModels.LoadingViewModel)
		case displaySearchError(HotelsSearchModels.ErrorViewModel)
		case displayFilters(HotelsSearchModels.FetchFilters.ViewModel)
		case displayUpdateFilters(HotelsSearchModels.FilterSelection.ViewModel)
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

	func displayFilters(viewModel: HotelsSearchModels.FetchFilters.ViewModel) {
		messages.append(.displayFilters(viewModel))
	}

	func displayUpdateFilters(viewModel: HotelsSearchModels.FilterSelection.ViewModel) {
		messages.append(.displayUpdateFilters(viewModel))
	}
}

//
//  HotelsSearchViewControllerTests.swift
//  HotelsDemoTests
//
//  Created by Denys Kotenko on 18/7/25.
//

import XCTest
import HotelsDemo

final class HotelsSearchViewControllerTests: XCTestCase, ListItemsRendererTestCase {
	func test_viewDidLoad_searchHotels() {
		let (sut, interactor) = makeSUT()

		sut.simulateAppearance()

		XCTAssertEqual(interactor.messages, [.search(.init())])
	}

	func test_displayCellControllers_rendersCells() {
		let viewModels: [HotelsSearchModels.HotelViewModel] = [
			.init(
				position: 0,
				starRating: 2,
				name: "Hotel",
				score: "6.9",
				reviews: "10 reviews",
				price: "US$123.99",
				priceDetails: "Tax included",
				photoURL: nil
			)
		]
		let cellControllers = viewModels.map(HotelCellController.init)
		let (sut, _) = makeSUT()

		sut.simulateAppearanceInWindow()
		assertThat(sut, isRendering: [])

		sut.display(cellControllers)
		assertThat(sut, isRendering: viewModels)
	}

	func test_displaySearchError_rendersErrorMessage() {
		let (sut, _) = makeSUT()
		sut.simulateAppearanceInWindow()

		sut.displaySearchError(viewModel: .init(message: "Some error message"))

		XCTAssertEqual(sut.errorMessage, "Some error message")
	}

	// MARK: - Helpers

	private func makeSUT() -> (
		sut: HotelsSearchViewController,
		interactor: SearchBusinessLogicSpy
	) {
		let interactor = SearchBusinessLogicSpy()
		let sut = HotelsSearchViewController()
		sut.interactor = interactor
		return (sut, interactor)
	}

	private func assertThat(
		_ sut: HotelsSearchViewController,
		isRendering viewModels: [HotelsSearchModels.HotelViewModel],
		file: StaticString = #filePath,
		line: UInt = #line
	) {
		assertThat(sut, isRendering: viewModels, assert: { view, viewModel, index in
			guard let cell = view as? HotelCell else {
				return XCTFail("Expected \(HotelCell.self) instance, got \(String(describing: view)) instead", file: file, line: line)
			}

			XCTAssertEqual(cell.nameLabel.text, viewModel.name, "Expected nameLabel to be \(viewModel.name), for hotel view at index \(index)", file: file, line: line)
			XCTAssertEqual(cell.scoreLabel.text, viewModel.score, "Expected scoreLabel to be \(viewModel.score), for hotel view at index \(index)", file: file, line: line)
			XCTAssertEqual(cell.reviewsLabel.text, viewModel.reviews, "Expected reviewsLabel to be \(viewModel.reviews), for hotel view at index \(index)", file: file, line: line)
			XCTAssertEqual(cell.priceLabel.text, viewModel.price, "Expected priceLabel to be \(viewModel.price), for hotel view at index \(index)", file: file, line: line)
			XCTAssertEqual(cell.priceDetailsLabel.text, viewModel.priceDetails, "Expected priceDetailsLabel to be \(viewModel.priceDetails), for hotel view at index \(index)", file: file, line: line)
		}, file: file, line: line)
	}
}

final class SearchBusinessLogicSpy: HotelsSearchBusinessLogic {
	enum Message: Equatable {
		case search(HotelsSearchModels.Search.Request)
		case cancelSearch
		case filter(HotelsSearchModels.Filter.Request)
		case updateFilter(HotelsSearchModels.UpdateFilter.Request)
	}

	private(set) var messages = [Message]()

	func search(request: HotelsSearchModels.Search.Request) {
		messages.append(.search(request))
	}

	func cancelSearch() {
		messages.append(.cancelSearch)
	}

	func filter(request: HotelsSearchModels.Filter.Request) {
		messages.append(.filter(request))
	}

	func updateFilter(request: HotelsSearchModels.UpdateFilter.Request) {
		messages.append(.updateFilter(request))
	}
}

extension HotelsSearchViewController: TableViewRenderer {
	var errorView: UIAlertController? {
		presentedViewController as? UIAlertController
	}

	var errorMessage: String? {
		errorView?.message
	}
}

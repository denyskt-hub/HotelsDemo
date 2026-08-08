//
//  HotelsSearchViewControllerTests.swift
//  HotelsDemoTests
//
//  Created by Denys Kotenko on 18/7/25.
//

import XCTest
import HotelsDemo

@MainActor
final class HotelsSearchViewControllerTests: XCTestCase, ListItemsRendererTestCase {
	func test_viewDidLoad_searchHotels() {
		let (sut, interactor, _) = makeSUT()

		sut.simulateAppearance()

		XCTAssertEqual(interactor.messages, [.handleViewDidAppear(.init())])
	}

	func test_displayLoading_rendersLoadingIndicator() {
		let (sut, _, _) = makeSUT()
		XCTAssertFalse(sut.isShowingLoadingIndicator)

		sut.displayLoading(true)
		XCTAssertTrue(sut.isShowingLoadingIndicator)

		sut.displayLoading(false)
		XCTAssertFalse(sut.isShowingLoadingIndicator)
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
		let cellControllers = viewModels.map { HotelCellController(viewModel: $0) }
		let (sut, _, _) = makeSUT()

		sut.simulateAppearanceInWindow()
		assertThat(sut, isRendering: [])

		sut.displayCellControllers(cellControllers)
		assertThat(sut, isRendering: viewModels)
	}

	func test_displayCellControllers_empty_showsEmptyState() {
		let viewModel = HotelsSearchModels.HotelViewModel(
			position: 0,
			starRating: 2,
			name: "Hotel",
			score: "6.9",
			reviews: "10 reviews",
			price: "US$123.99",
			priceDetails: "Tax included",
			photoURL: nil
		)
		let (sut, _, _) = makeSUT()
		sut.simulateAppearanceInWindow()

		sut.displayCellControllers([])
		XCTAssertTrue(sut.isShowingPlaceholder)
		XCTAssertEqual(sut.placeholderMessage?.isEmpty, false)
		XCTAssertNil(sut.placeholderActionTitle, "An empty result is not something the user can retry")

		sut.displayCellControllers([HotelCellController(viewModel: viewModel)])
		XCTAssertFalse(sut.isShowingPlaceholder)
	}

	func test_displaySearchFailure_rendersErrorWithRetryInPlaceOfTheList() {
		let (sut, _, _) = makeSUT()
		sut.simulateAppearanceInWindow()

		sut.displaySearchFailure("Some error message")

		XCTAssertEqual(sut.placeholderMessage, "Some error message")
		XCTAssertEqual(sut.placeholderActionTitle?.isEmpty, false, "A failed load must offer a way out")
		XCTAssertNil(sut.presentedViewController, "The error belongs on the screen, not in an alert")
	}

	func test_retryTap_requestsSearchAgain() {
		let (sut, interactor, _) = makeSUT()
		sut.simulateAppearanceInWindow()
		sut.displaySearchFailure("Some error message")

		sut.simulateRetryTap()

		XCTAssertEqual(interactor.messages.last, .handleRetry(.init()))
	}

	func test_displayCellControllers_afterError_clearsErrorState() {
		let viewModel = HotelsSearchModels.HotelViewModel(
			position: 0,
			starRating: 2,
			name: "Hotel",
			score: "6.9",
			reviews: "10 reviews",
			price: "US$123.99",
			priceDetails: "Tax included",
			photoURL: nil
		)
		let (sut, _, _) = makeSUT()
		sut.simulateAppearanceInWindow()
		sut.displaySearchFailure("Some error message")

		sut.displayCellControllers([HotelCellController(viewModel: viewModel)])

		XCTAssertFalse(sut.isShowingPlaceholder)
	}

	func test_displayLoading_clearsErrorState() {
		let (sut, _, _) = makeSUT()
		sut.simulateAppearanceInWindow()
		sut.displaySearchFailure("Some error message")

		sut.displayLoading(true)

		XCTAssertFalse(sut.isShowingPlaceholder, "A retry in flight should not sit under the error it is retrying")
	}

	func test_displayFilter_routesToHotelFiltersPicker() {
		let filters = anyHotelFilters()
		let (sut, _, router) = makeSUT()

		sut.displayFilters(filters)

		XCTAssertEqual(router.messages, [.routeToHotelsFilterPicker(filters)])
	}

	func test_filterTap_presentsFilter() {
		let (sut, interactor, _) = makeSUT()
		sut.simulateAppearance()

		sut.simulateFilterButtonTap()

		XCTAssertEqual(interactor.messages.last, .doFetchFilters(.init()))
	}

	func test_didSelectFilters_updatesFiters() {
		let filters = anyHotelFilters()
		let (sut, interactor, _) = makeSUT()

		sut.didSelectFilters(filters)

		XCTAssertEqual(interactor.messages, [.handleFilterSelection(.init(filters: filters))])
	}

	// MARK: - Helpers

	private func makeSUT() -> (
		sut: HotelsSearchViewController,
		interactor: SearchBusinessLogicSpy,
		router: HotelsSearchRoutingLogicSpy
	) {
		let interactor = SearchBusinessLogicSpy()
		let router = HotelsSearchRoutingLogicSpy()
		let sut = HotelsSearchViewController(
			interactor: interactor,
			router: router
		)
		trackForMemoryLeaks(interactor)
		trackForMemoryLeaks(router)
		trackForMemoryLeaks(sut)
		return (sut, interactor, router)
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
		case doFetchFilters(HotelsSearchModels.FetchFilters.Request)
		case handleViewDidAppear(HotelsSearchModels.ViewDidAppear.Request)
		case handleViewWillDisappearFromParent(HotelsSearchModels.ViewWillDisappearFromParent.Request)
		case handleRetry(HotelsSearchModels.Retry.Request)
		case handleFilterSelection(HotelsSearchModels.FilterSelection.Request)
	}

	private(set) var messages = [Message]()

	func doFetchFilters(request: HotelsSearchModels.FetchFilters.Request) {
		messages.append(.doFetchFilters(request))
	}

	func handleViewDidAppear(request: HotelsSearchModels.ViewDidAppear.Request) {
		messages.append(.handleViewDidAppear(request))
	}

	func handleViewWillDisappearFromParent(request: HotelsSearchModels.ViewWillDisappearFromParent.Request) {
		messages.append(.handleViewWillDisappearFromParent(request))
	}

	func handleRetry(request: HotelsSearchModels.Retry.Request) {
		messages.append(.handleRetry(request))
	}

	func handleFilterSelection(request: HotelsSearchModels.FilterSelection.Request) {
		messages.append(.handleFilterSelection(request))
	}
}

final class HotelsSearchRoutingLogicSpy: HotelsSearchRoutingLogic {
	enum Message: Equatable {
		case routeToHotelsFilterPicker(HotelFilters)
	}

	private(set) var messages = [Message]()

	func routeToHotelFiltersPicker(_ filters: HotelFilters) {
		messages.append(.routeToHotelsFilterPicker(filters))
	}
}

extension HotelsSearchViewController: TableViewRenderer {
	var isShowingLoadingIndicator: Bool {
		!loadingView.isHidden && loadingView.isAnimating
	}

	var isShowingPlaceholder: Bool {
		tableView.backgroundView === placeholderView
	}

	var placeholderMessage: String? {
		isShowingPlaceholder ? placeholderView.messageLabel.text : nil
	}

	var placeholderActionTitle: String? {
		guard isShowingPlaceholder, !placeholderView.actionButton.isHidden else {
			return nil
		}
		return placeholderView.actionButton.configuration?.title
	}

	func simulateFilterButtonTap() {
		filterButton.simulateTap()
	}

	func simulateRetryTap() {
		placeholderView.actionButton.simulateTap()
	}
}

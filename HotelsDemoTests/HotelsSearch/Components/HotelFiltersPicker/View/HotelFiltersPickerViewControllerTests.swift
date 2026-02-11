//
//  HotelFiltersPickerViewControllerTests.swift
//  HotelsDemoTests
//
//  Created by Denys Kotenko on 27/7/25.
//

import XCTest
import HotelsDemo

@MainActor
final class HotelFiltersPickerViewControllerTests: XCTestCase {
	func test_viewDidLoad_loadsInitialData() {
		let (sut, interactor, _) = makeSUT()

		sut.simulateAppearance()
		
		XCTAssertEqual(interactor.messages, [.doFetchFilters(.init())])
	}

	func test_display_rendersHasSelectedFiltersState() {
		let (sut, _, _) = makeSUT()

		sut.display(viewModel: .init(hasSelectedFilters: false))
		XCTAssertFalse(sut.resetButton.isEnabled)

		sut.display(viewModel: .init(hasSelectedFilters: true))
		XCTAssertTrue(sut.resetButton.isEnabled)
	}

	func test_displaySelectedFilters_notifiesDelegateWithSelectedFilters() {
		let filters = anyHotelFilters()
		let (sut, _, delegate) = makeSUT()

		sut.displaySelectedFilters(viewModel: .init(filters: filters))

		XCTAssertEqual(delegate.messages, [.didSelectFilters(filters)])
	}

	func test_displayResetFilters_callsResetOnEachFilterViewController() {
		let filterViewControllers = [
			ResetableFilterViewControllerSpy(),
			ResetableFilterViewControllerSpy()
		]
		let (sut, _, _) = makeSUT(filterViewControllers: filterViewControllers)

		sut.displayResetFilters(viewModel: .init())

		filterViewControllers.forEach { filterViewController in
			XCTAssertEqual(filterViewController.messages, [.reset])
		}
	}

	func test_applyButtonTap_selectsFilters() {
		let (sut, interactor, _) = makeSUT()
		sut.simulateAppearance()

		sut.simulateApplyButtonTap()

		XCTAssertEqual(interactor.messages, [
			.doFetchFilters(.init()),
			.handleFilterSelection(.init())
		])
	}

	func test_resetButtonTap_resetsFilters() {
		let (sut, interactor, _) = makeSUT()
		sut.simulateAppearance()
		
		sut.simulateResetButtonTap()

		XCTAssertEqual(interactor.messages, [
			.doFetchFilters(.init()),
			.handleFilterReset(.init())
		])
	}

	func test_didSelectPriceRange_updatesPriceRange() {
		let (sut, interactor, _) = makeSUT()

		sut.didSelectPriceRange(nil)
		XCTAssertEqual(interactor.messages.last, .handlePriceRangeSelection(.init(priceRange: nil)))

		sut.didSelectPriceRange(10...200)
		XCTAssertEqual(interactor.messages.last, .handlePriceRangeSelection(.init(priceRange: 10...200)))

		sut.didSelectPriceRange(100...300)
		XCTAssertEqual(interactor.messages.last, .handlePriceRangeSelection(.init(priceRange: 100...300)))
	}

	func test_didSelectStarRatings_updateStarRatings() {
		let (sut, interactor, _) = makeSUT()

		sut.didSelectStarRatings([])
		XCTAssertEqual(interactor.messages.last, .handleStarRatingSelection(.init(starRatings: [])))

		sut.didSelectStarRatings([.five])
		XCTAssertEqual(interactor.messages.last, .handleStarRatingSelection(.init(starRatings: [.five])))

		sut.didSelectStarRatings([.one, .two])
		XCTAssertEqual(interactor.messages.last, .handleStarRatingSelection(.init(starRatings: [.one, .two])))
	}

	func test_didSelectReviewScore_updateReviewScore() {
		let (sut, interactor, _) = makeSUT()

		sut.didSelectReviewScore(nil)
		XCTAssertEqual(interactor.messages.last, .handleReviewScoreSelection(.init(reviewScore: nil)))

		sut.didSelectReviewScore(.fair)
		XCTAssertEqual(interactor.messages.last, .handleReviewScoreSelection(.init(reviewScore: .fair)))

		sut.didSelectReviewScore(.good)
		XCTAssertEqual(interactor.messages.last, .handleReviewScoreSelection(.init(reviewScore: .good)))
	}

	// MARK: - Helpers

	private func makeSUT(filterViewControllers: [ResetableFilterViewController] = []) -> (
		sut: HotelFiltersPickerViewController,
		interactor: HotelFiltersPickerBusinessLogicSpy,
		delegate: HotelFiltersPickerDelegateSpy
	) {
		let interactor = HotelFiltersPickerBusinessLogicSpy()
		let delegate = HotelFiltersPickerDelegateSpy()
		let sut = HotelFiltersPickerViewController(
			filterViewControllers: filterViewControllers,
			interactor: interactor,
			delegate: delegate
		)
		return (sut, interactor, delegate)
	}
}

extension HotelFiltersPickerViewController {
	func simulateApplyButtonTap() {
		applyButton.simulateTap()
	}

	func simulateResetButtonTap() {
		resetButton.simulateTap()
	}
}

final class ResetableFilterViewControllerSpy: UIViewController, ResetableFilterViewController {
	enum Message: Equatable {
		case reset
	}
	
	private(set) var messages = [Message]()

	func reset() {
		messages.append(.reset)
	}
}

final class HotelFiltersPickerBusinessLogicSpy: HotelFiltersPickerBusinessLogic {
	enum Message: Equatable {
		case doFetchFilters(HotelFiltersPickerModels.FetchFilters.Request)
		case handlePriceRangeSelection(HotelFiltersPickerModels.PriceRangeSelection.Request)
		case handleStarRatingSelection(HotelFiltersPickerModels.StarRatingSelection.Request)
		case handleReviewScoreSelection(HotelFiltersPickerModels.ReviewScoreSelection.Request)
		case handleFilterSelection(HotelFiltersPickerModels.FilterSelection.Request)
		case handleFilterReset(HotelFiltersPickerModels.FilterReset.Request)
	}

	private(set) var messages = [Message]()

	func doFetchFilters(request: HotelFiltersPickerModels.FetchFilters.Request) {
		messages.append(.doFetchFilters(request))
	}

	func handlePriceRangeSelection(request: HotelFiltersPickerModels.PriceRangeSelection.Request) {
		messages.append(.handlePriceRangeSelection(request))
	}

	func handleStarRatingSelection(request: HotelFiltersPickerModels.StarRatingSelection.Request) {
		messages.append(.handleStarRatingSelection(request))
	}

	func handleReviewScoreSelection(request: HotelFiltersPickerModels.ReviewScoreSelection.Request) {
		messages.append(.handleReviewScoreSelection(request))
	}

	func handleFilterSelection(request: HotelFiltersPickerModels.FilterSelection.Request) {
		messages.append(.handleFilterSelection(request))
	}

	func handleFilterReset(request: HotelFiltersPickerModels.FilterReset.Request) {
		messages.append(.handleFilterReset(request))
	}
}

final class HotelFiltersPickerDelegateSpy: HotelFiltersPickerDelegate {
	enum Message: Equatable {
		case didSelectFilters(HotelFilters)
	}

	private(set) var messages = [Message]()

	func didSelectFilters(_ filters: HotelFilters) {
		messages.append(.didSelectFilters(filters))
	}
}

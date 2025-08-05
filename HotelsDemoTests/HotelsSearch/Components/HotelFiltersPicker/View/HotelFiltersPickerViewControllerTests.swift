//
//  HotelFiltersPickerViewControllerTests.swift
//  HotelsDemoTests
//
//  Created by Denys Kotenko on 27/7/25.
//

import XCTest
import HotelsDemo

final class HotelFiltersPickerViewControllerTests: XCTestCase {
	func test_viewDidLoad_loadsInitialData() {
		let (sut, interactor, _) = makeSUT()

		sut.simulateAppearance()
		
		XCTAssertEqual(interactor.messages, [.load(.init())])
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
			.load(.init()),
			.selectFilters(.init())
		])
	}

	func test_resetButtonTap_resetsFilters() {
		let (sut, interactor, _) = makeSUT()
		sut.simulateAppearance()
		
		sut.simulateResetButtonTap()

		XCTAssertEqual(interactor.messages, [
			.load(.init()),
			.resetFilters(.init())
		])
	}

	func test_didSelectPriceRange_updatesPriceRange() {
		let (sut, interactor, _) = makeSUT()

		sut.didSelectPriceRange(nil)
		XCTAssertEqual(interactor.messages.last, .updatePriceRange(.init(priceRange: nil)))

		sut.didSelectPriceRange(10...200)
		XCTAssertEqual(interactor.messages.last, .updatePriceRange(.init(priceRange: 10...200)))

		sut.didSelectPriceRange(100...300)
		XCTAssertEqual(interactor.messages.last, .updatePriceRange(.init(priceRange: 100...300)))
	}

	func test_didSelectStarRatings_updateStarRatings() {
		let (sut, interactor, _) = makeSUT()

		sut.didSelectStarRatings([])
		XCTAssertEqual(interactor.messages.last, .updateStarRatings(.init(starRatings: [])))

		sut.didSelectStarRatings([.five])
		XCTAssertEqual(interactor.messages.last, .updateStarRatings(.init(starRatings: [.five])))

		sut.didSelectStarRatings([.one, .two])
		XCTAssertEqual(interactor.messages.last, .updateStarRatings(.init(starRatings: [.one, .two])))
	}

	func test_didSelectReviewScore_updateReviewScore() {
		let (sut, interactor, _) = makeSUT()

		sut.didSelectReviewScore(nil)
		XCTAssertEqual(interactor.messages.last, .updateReviewScore(.init(reviewScore: nil)))

		sut.didSelectReviewScore(.fair)
		XCTAssertEqual(interactor.messages.last, .updateReviewScore(.init(reviewScore: .fair)))

		sut.didSelectReviewScore(.good)
		XCTAssertEqual(interactor.messages.last, .updateReviewScore(.init(reviewScore: .good)))
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
			filterViewControllers: filterViewControllers
		)
		sut.interactor = interactor
		sut.delegate = delegate
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
		case load(HotelFiltersPickerModels.Load.Request)
		case updatePriceRange(HotelFiltersPickerModels.UpdatePriceRange.Request)
		case updateStarRatings(HotelFiltersPickerModels.UpdateStarRatings.Request)
		case updateReviewScore(HotelFiltersPickerModels.UpdateReviewScore.Request)
		case selectFilters(HotelFiltersPickerModels.Select.Request)
		case resetFilters(HotelFiltersPickerModels.Reset.Request)
	}

	private(set) var messages = [Message]()

	func load(request: HotelFiltersPickerModels.Load.Request) {
		messages.append(.load(request))
	}

	func updatePriceRange(request: HotelFiltersPickerModels.UpdatePriceRange.Request) {
		messages.append(.updatePriceRange(request))
	}

	func updateStarRatings(request: HotelFiltersPickerModels.UpdateStarRatings.Request) {
		messages.append(.updateStarRatings(request))
	}

	func updateReviewScore(request: HotelFiltersPickerModels.UpdateReviewScore.Request) {
		messages.append(.updateReviewScore(request))
	}

	func selectFilters(request: HotelFiltersPickerModels.Select.Request) {
		messages.append(.selectFilters(request))
	}

	func resetFilters(request: HotelFiltersPickerModels.Reset.Request) {
		messages.append(.resetFilters(request))
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

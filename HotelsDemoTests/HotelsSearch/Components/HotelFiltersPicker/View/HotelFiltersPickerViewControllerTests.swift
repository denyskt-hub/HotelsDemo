//
//  HotelFiltersPickerViewControllerTests.swift
//  HotelsDemoTests
//
//  Created by Denys Kotenko on 27/7/25.
//

import XCTest
import HotelsDemo

final class HotelFiltersPickerViewControllerTests: XCTestCase {
	func test_displaySelectedFilters_notifiesDelegateWithSelectedFilters() {
		let filters = anyHotelFilters()
		let (sut, _, _, delegate) = makeSUT()

		sut.displaySelectedFilters(viewModel: .init(filters: filters))

		XCTAssertEqual(delegate.messages, [.didSelectFilters(filters)])
	}

	func test_displayResetFilters_callsResetOnEachFilterViewController() {
		let (sut, filterViewControllers, _, _) = makeSUT()

		sut.displayResetFilters(viewModel: .init())

		filterViewControllers.forEach { filterViewController in
			XCTAssertEqual(filterViewController.messages, [.reset])
		}
	}

	// MARK: - Helpers

	private func makeSUT() -> (
		sut: HotelFiltersPickerViewController,
		filterViewControllers: [ResetableFilterViewControllerSpy],
		interactor: HotelFiltersPickerBusinessLogicSpy,
		delegate: HotelFiltersPickerDelegateSpy
	) {
		let filterViewControllers = [
			ResetableFilterViewControllerSpy(),
			ResetableFilterViewControllerSpy()
		]
		let interactor = HotelFiltersPickerBusinessLogicSpy()
		let delegate = HotelFiltersPickerDelegateSpy()
		let sut = HotelFiltersPickerViewController(
			filterViewControllers: filterViewControllers
		)
		sut.interactor = interactor
		sut.delegate = delegate
		return (sut, filterViewControllers, interactor, delegate)
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
		case updatePriceRange(HotelFiltersPickerModels.UpdatePriceRange.Request)
		case updateStarRatings(HotelFiltersPickerModels.UpdateStarRatings.Request)
		case updateReviewScore(HotelFiltersPickerModels.UpdateReviewScore.Request)
		case selectFilters(HotelFiltersPickerModels.Select.Request)
		case resetFilters(HotelFiltersPickerModels.Reset.Request)
	}

	private(set) var messages = [Message]()

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

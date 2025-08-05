//
//  HotelFiltersPickerPresenterTests.swift
//  HotelsDemoTests
//
//  Created by Denys Kotenko on 27/7/25.
//

import XCTest
import HotelsDemo

final class HotelFiltersPickerPresenterTests: XCTestCase {
	func test_present_displaysResetButtonState() {
		let (sut, viewController) = makeSUT()

		sut.present(response: .init(filters: emptyHotelFilters()))
		XCTAssertEqual(viewController.messages.last, .display(.init(hasSelectedFilters: false)))

		sut.present(response: .init(filters: nonEmptyHotelFilters()))
		XCTAssertEqual(viewController.messages.last, .display(.init(hasSelectedFilters: true)))
	}

	func test_presentSelectedFilters_displaysSelectedFilters() {
		let filters = anyHotelFilters()
		let (sut, viewController) = makeSUT()

		sut.presentSelectedFilters(response: .init(filters: filters))

		XCTAssertEqual(viewController.messages, [
			.displaySelectedFilters(.init(filters: filters))
		])
	}

	func test_presentResetFilters_displaysResetFilters() {
		let (sut, viewController) = makeSUT()

		sut.presentResetFilters(response: .init())

		XCTAssertEqual(viewController.messages, [
			.displayResetFilters(.init())
		])
	}

	// MARK: - Helpers

	private func makeSUT() -> (
		sut: HotelFiltersPickerPresenter,
		viewController: HotelFiltersPickerDisplayLogicSpy
	) {
		let viewController = HotelFiltersPickerDisplayLogicSpy()
		let sut = HotelFiltersPickerPresenter()
		sut.viewController = viewController
		return (sut, viewController)
	}
}

final class HotelFiltersPickerDisplayLogicSpy: HotelFiltersPickerDisplayLogic {
	enum Message: Equatable {
		case display(HotelFiltersPickerModels.Load.ViewModel)
		case displaySelectedFilters(HotelFiltersPickerModels.Select.ViewModel)
		case displayResetFilters(HotelFiltersPickerModels.Reset.ViewModel)
	}

	private(set) var messages = [Message]()

	func display(viewModel: HotelFiltersPickerModels.Load.ViewModel) {
		messages.append(.display(viewModel))
	}

	func displaySelectedFilters(viewModel: HotelFiltersPickerModels.Select.ViewModel) {
		messages.append(.displaySelectedFilters(viewModel))
	}

	func displayResetFilters(viewModel: HotelFiltersPickerModels.Reset.ViewModel) {
		messages.append(.displayResetFilters(viewModel))
	}
}

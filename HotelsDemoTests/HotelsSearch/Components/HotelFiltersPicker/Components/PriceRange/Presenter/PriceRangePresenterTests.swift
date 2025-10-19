//
//  PriceRangePresenterTests.swift
//  HotelsDemoTests
//
//  Created by Denys Kotenko on 31/7/25.
//

import XCTest
import HotelsDemo

final class PriceRangePresenterTests: XCTestCase {
	func test_present_displaysPriceRange() {
		let (sut, viewController) = makeSUT()

		sut.present(response: .init(availablePriceRange: 0...100, priceRange: nil, currencyCode: "USD"))
		var expectedViewModel = PriceRangeModels.PriceRangeViewModel(
			availablePriceRange: 0...100,
			priceRange: 0...100,
			lowerValue: "$0.00",
			upperValue: "$100.00"
		)
		XCTAssertEqual(viewController.messages.last, .display(.init(priceRangeViewModel: expectedViewModel)))

		sut.present(response: .init(availablePriceRange: 0...100, priceRange: 20...70, currencyCode: "USD"))
		expectedViewModel = PriceRangeModels.PriceRangeViewModel(
			availablePriceRange: 0...100,
			priceRange: 20...70,
			lowerValue: "$20.00",
			upperValue: "$70.00"
		)
		XCTAssertEqual(viewController.messages.last, .display(.init(priceRangeViewModel: expectedViewModel)))
	}

	func test_presentReset_presentsReset() {
		let (sut, viewController) = makeSUT()
		
		sut.presentReset(response: .init(availablePriceRange: 0...100, currencyCode: "USD"))
		
		let expectedViewModel = PriceRangeModels.PriceRangeViewModel(
			availablePriceRange: 0...100,
			priceRange: 0...100,
			lowerValue: "$0.00",
			upperValue: "$100.00"
		)
		XCTAssertEqual(viewController.messages.last, .displayReset(.init(priceRangeViewModel: expectedViewModel)))
	}

	func test_presentSelect_presentsSelect() {
		let (sut, viewController) = makeSUT()

		sut.presentSelect(response: .init(priceRange: 50...80))

		XCTAssertEqual(viewController.messages.last, .displaySelect(.init(priceRange: 50...80)))
	}

	func test_presentSelecting_presentsSelecting() {
		let (sut, viewController) = makeSUT()
		
		sut.presentSelecting(response: .init(priceRange: 50...80, currencyCode: "USD"))
		
		XCTAssertEqual(viewController.messages.last, .displaySelecting(.init(lowerValue: "$50.00", upperValue: "$80.00")))
	}

	// MARK: - Helpers

	private func makeSUT(locale: Locale = Locale(identifier: "en_US")) -> (
		sut: PriceRangePresenter,
		viewController: PriceRangeDisplayLogicSpy
	) {
		let viewController = PriceRangeDisplayLogicSpy()
		let sut = PriceRangePresenter(
			viewController: viewController,
			locale: locale
		)
		return (sut, viewController)
	}
}

final class PriceRangeDisplayLogicSpy: PriceRangeDisplayLogic {
	enum Message: Equatable {
		case display(PriceRangeModels.FetchPriceRange.ViewModel)
		case displayReset(PriceRangeModels.PriceRangeReset.ViewModel)
		case displaySelect(PriceRangeModels.PriceRangeSelection.ViewModel)
		case displaySelecting(PriceRangeModels.SelectingPriceRange.ViewModel)
	}

	private(set) var messages = [Message]()

	func display(viewModel: PriceRangeModels.FetchPriceRange.ViewModel) {
		messages.append(.display(viewModel))
	}

	func displayReset(viewModel: PriceRangeModels.PriceRangeReset.ViewModel) {
		messages.append(.displayReset(viewModel))
	}

	func displaySelect(viewModel: PriceRangeModels.PriceRangeSelection.ViewModel) {
		messages.append(.displaySelect(viewModel))
	}

	func displaySelecting(viewModel: PriceRangeModels.SelectingPriceRange.ViewModel) {
		messages.append(.displaySelecting(viewModel))
	}
}

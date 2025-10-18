//
//  PriceRangeInteractorTests.swift
//  HotelsDemoTests
//
//  Created by Denys Kotenko on 31/7/25.
//

import XCTest
import HotelsDemo

final class PriceRangeInteractorTests: XCTestCase {
	func test_doFetchPriceRange_presentsInitialState() {
		let cases: [(ClosedRange<Decimal>?, String, String)] = [
			(nil, "USD", "when nothing selected"),
			(100...500, "THB", "when something is selected")
		]

		cases.forEach { selectedPriceRange, currencyCode, description in
			let (sut, presenter) = makeSUT(selectedPriceRange: selectedPriceRange, currencyCode: currencyCode)

			sut.doFetchPriceRange(request: .init())

			XCTAssertEqual(presenter.messages, [
				.present(.init(availablePriceRange: 0...3000, priceRange: selectedPriceRange, currencyCode: currencyCode))
			], description)
		}
	}

	func test_handlePriceRangeReset_presentsResetState() {
		let (sut, presenter) = makeSUT(selectedPriceRange: 10...30, currencyCode: "USD")

		sut.handlePriceRangeReset(request: .init())

		XCTAssertEqual(presenter.messages, [.presentReset(.init(availablePriceRange: 0...3000, currencyCode: "USD"))])
	}

	func test_handlePriceRangeSelection_presentsSelectedPriceRange() {
		let (sut, presenter) = makeSUT(selectedPriceRange: nil)

		sut.handlePriceRangeSelection(request: .init(priceRange: 20...60))

		XCTAssertEqual(presenter.messages, [.presentSelect(.init(priceRange: 20...60))])
	}

	func test_handleSelectingPriceRange_prsentsSelectingPriceRange() {
		let (sut, presenter) = makeSUT(selectedPriceRange: nil, currencyCode: "THB")

		sut.handleSelectingPriceRange(request: .init(priceRange: 300...900))

		XCTAssertEqual(presenter.messages, [.presentSelecting(.init(priceRange: 300...900, currencyCode: "THB"))])
	}

	// MARK: - Helpers

	private func makeSUT(
		selectedPriceRange: ClosedRange<Decimal>? = nil,
		currencyCode: String = "USD"
	) -> (
		sut: PriceRangeInteractor,
		presenter: PriceRangePresentationLogicSpy
	) {
		let presenter = PriceRangePresentationLogicSpy()
		let sut = PriceRangeInteractor(
			selectedPriceRange: selectedPriceRange,
			currencyCode: currencyCode,
			presenter: presenter
		)
		return (sut, presenter)
	}
}

final class PriceRangePresentationLogicSpy: PriceRangePresentationLogic {
	enum Message: Equatable {
		case present(PriceRangeModels.FetchPriceRange.Response)
		case presentReset(PriceRangeModels.PriceRangeReset.Response)
		case presentSelect(PriceRangeModels.PriceRangeSelection.Response)
		case presentSelecting(PriceRangeModels.SelectingPriceRange.Response)
	}

	private(set) var messages = [Message]()

	func present(response: PriceRangeModels.FetchPriceRange.Response) {
		messages.append(.present(response))
	}

	func presentReset(response: PriceRangeModels.PriceRangeReset.Response) {
		messages.append(.presentReset(response))
	}

	func presentSelect(response: PriceRangeModels.PriceRangeSelection.Response) {
		messages.append(.presentSelect(response))
	}

	func presentSelecting(response: PriceRangeModels.SelectingPriceRange.Response) {
		messages.append(.presentSelecting(response))
	}
}

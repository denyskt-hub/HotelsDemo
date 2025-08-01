//
//  PriceRangeInteractorTests.swift
//  HotelsDemoTests
//
//  Created by Denys Kotenko on 31/7/25.
//

import XCTest
import HotelsDemo

final class PriceRangeInteractorTests: XCTestCase {
	func test_load_presentsInitialState() {
		let cases: [(ClosedRange<Decimal>?, String, String)] = [
			(nil, "USD", "when nothing selected"),
			(100...500, "THB", "when something is selected")
		]

		cases.forEach { selectedPriceRange, currencyCode, description in
			let (sut, presenter) = makeSUT(selectedPriceRange: selectedPriceRange, currencyCode: currencyCode)

			sut.load(request: .init())

			XCTAssertEqual(presenter.messages, [
				.present(.init(availablePriceRange: 0...3000, priceRange: selectedPriceRange, currencyCode: currencyCode))
			], description)
		}
	}

	func test_reset_presentsResetState() {
		let (sut, presenter) = makeSUT(selectedPriceRange: 10...30, currencyCode: "USD")

		sut.reset(request: .init())

		XCTAssertEqual(presenter.messages, [.presentReset(.init(availablePriceRange: 0...3000, currencyCode: "USD"))])
	}

	func test_select_presentsSelectedPriceRange() {
		let (sut, presenter) = makeSUT(selectedPriceRange: nil)

		sut.select(request: .init(priceRange: 20...60))

		XCTAssertEqual(presenter.messages, [.presentSelect(.init(priceRange: 20...60))])
	}

	func test_selecting_prsentsSelectingPriceRange() {
		let (sut, presenter) = makeSUT(selectedPriceRange: nil, currencyCode: "THB")

		sut.selecting(request: .init(priceRange: 300...900))

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
			currencyCode: currencyCode
		)
		sut.presenter = presenter
		return (sut, presenter)
	}
}

final class PriceRangePresentationLogicSpy: PriceRangePresentationLogic {
	enum Message: Equatable {
		case present(PriceRangeModels.Load.Response)
		case presentReset(PriceRangeModels.Reset.Response)
		case presentSelect(PriceRangeModels.Select.Response)
		case presentSelecting(PriceRangeModels.Selecting.Response)
	}

	private(set) var messages = [Message]()

	func present(response: PriceRangeModels.Load.Response) {
		messages.append(.present(response))
	}

	func presentReset(response: PriceRangeModels.Reset.Response) {
		messages.append(.presentReset(response))
	}

	func presentSelect(response: PriceRangeModels.Select.Response) {
		messages.append(.presentSelect(response))
	}

	func presentSelecting(response: PriceRangeModels.Selecting.Response) {
		messages.append(.presentSelecting(response))
	}
}

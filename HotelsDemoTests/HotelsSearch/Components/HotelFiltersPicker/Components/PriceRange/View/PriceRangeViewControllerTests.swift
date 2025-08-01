//
//  PriceRangeViewControllerTests.swift
//  HotelsDemoTests
//
//  Created by Denys Kotenko on 31/7/25.
//

import XCTest
import HotelsDemo

final class PriceRangeViewControllerTests: XCTestCase {
	func test_viewDidLoad_loadsInitialData() {
		let (sut, interactor, _) = makeSUT()

		sut.simulateAppearance()

		XCTAssertEqual(interactor.messages, [.load(.init())])
	}

	func test_reset_resetsSelectedPriceRange() {
		let (sut, interactor, _) = makeSUT()

		sut.reset()

		XCTAssertEqual(interactor.messages, [.reset(.init())])
	}

	func test_sliderValueChanged_slectingPriceRange() {
		let (sut, interactor, _) = makeSUT()
		sut.simulateAppearance()
		sut.display(viewModel: makeLoadViewModelWith(priceRange: .none, in: 0...500))

		sut.simulateSliderLowerValueChanged(to: 20)
		XCTAssertEqual(interactor.messages.last, .selecting(.init(priceRange: 20...500)))

		sut.simulateSliderUpperValueChanged(to: 30)
		XCTAssertEqual(interactor.messages.last, .selecting(.init(priceRange: 20...30)))
	}

	func test_sliderEditingDidEnd_selectsPriceRange() {
		let (sut, interactor, _) = makeSUT()
		sut.simulateAppearance()
		sut.display(viewModel: makeLoadViewModelWith(priceRange: .none, in: 0...500))

		sut.simulateSliderLowerEditingDidEnd(to: 20)
		XCTAssertEqual(interactor.messages.last, .select(.init(priceRange: 20...500)))

		sut.simulateSliderUpperEditingDidEnd(to: 30)
		XCTAssertEqual(interactor.messages.last, .select(.init(priceRange: 20...30)))
	}

	func test_display_rendersPriceRange() {
		let viewModel = makeLoadViewModelWith(priceRange: 100...200, in: 0...500)
		let (sut, _, _) = makeSUT()
		sut.simulateAppearance()

		sut.display(viewModel: viewModel)

		assertThat(sut, isRendering: viewModel.priceRangeViewModel)
	}

	// MARK: - Helpers

	private func makeSUT() -> (
		sut: PriceRangeViewController,
		interactor: PriceRangeBusinessLogicSpy,
		delegate: PriceRangeDelegateSpy
	) {
		let interactor = PriceRangeBusinessLogicSpy()
		let delegate = PriceRangeDelegateSpy()
		let sut = PriceRangeViewController()
		sut.interactor = interactor
		sut.delegate = delegate
		return (sut, interactor, delegate)
	}

	private func makeLoadViewModelWith(
		priceRange: ClosedRange<Decimal>?,
		in availablePriceRange: ClosedRange<Decimal>,
		lowerValue: String = "lower",
		upperValue: String = "upper"
	) -> PriceRangeModels.Load.ViewModel {
		.init(
			priceRangeViewModel: .init(
				availablePriceRange: availablePriceRange,
				priceRange: priceRange ?? availablePriceRange,
				lowerValue: lowerValue,
				upperValue: upperValue
			)
		)
	}

	private func assertThat(
		_ sut: PriceRangeViewController,
		isRendering viewModel: PriceRangeModels.PriceRangeViewModel,
		file: StaticString = #filePath,
		line: UInt = #line
	) {
		XCTAssertEqual(sut.slider.minimumValue, viewModel.availablePriceRange.lowerBound.cgFloatValue)
		XCTAssertEqual(sut.slider.maximumValue, viewModel.availablePriceRange.upperBound.cgFloatValue)

		XCTAssertEqual(sut.slider.lowerValue, viewModel.priceRange.lowerBound.cgFloatValue)
		XCTAssertEqual(sut.slider.upperValue, viewModel.priceRange.upperBound.cgFloatValue)

		XCTAssertEqual(sut.lowerValueLabel.text, viewModel.lowerValue)
		XCTAssertEqual(sut.upperValueLabel.text, viewModel.upperValue)
	}
}

final class PriceRangeBusinessLogicSpy: PriceRangeBusinessLogic {
	enum Message: Equatable {
		case load(PriceRangeModels.Load.Request)
		case reset(PriceRangeModels.Reset.Request)
		case select(PriceRangeModels.Select.Request)
		case selecting(PriceRangeModels.Selecting.Request)
	}

	private(set) var messages = [Message]()

	func load(request: PriceRangeModels.Load.Request) {
		messages.append(.load(request))
	}
	
	func reset(request: PriceRangeModels.Reset.Request) {
		messages.append(.reset(request))
	}
	
	func select(request: PriceRangeModels.Select.Request) {
		messages.append(.select(request))
	}
	
	func selecting(request: PriceRangeModels.Selecting.Request) {
		messages.append(.selecting(request))
	}
}

final class PriceRangeDelegateSpy: PriceRangeDelegate {
	enum Message: Equatable {
		case didSelectPriceRange(ClosedRange<Decimal>?)
	}

	private(set) var messages = [Message]()

	func didSelectPriceRange(_ priceRange: ClosedRange<Decimal>?) {
		messages.append(.didSelectPriceRange(priceRange))
	}
}

extension PriceRangeViewController {
	func simulateSliderLowerValueChanged(to value: Decimal) {
		slider.lowerValue = value.cgFloatValue
		slider.sendActions(for: .valueChanged)
	}

	func simulateSliderUpperValueChanged(to value: Decimal) {
		slider.upperValue = value.cgFloatValue
		slider.sendActions(for: .valueChanged)
	}

	func simulateSliderLowerEditingDidEnd(to value: Decimal) {
		slider.lowerValue = value.cgFloatValue
		slider.sendActions(for: .editingDidEnd)
	}

	func simulateSliderUpperEditingDidEnd(to value: Decimal) {
		slider.upperValue = value.cgFloatValue
		slider.sendActions(for: .editingDidEnd)
	}
}

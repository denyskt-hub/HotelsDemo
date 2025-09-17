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

		XCTAssertEqual(interactor.messages, [.doFetchPriceRange(.init())])
	}

	func test_reset_resetsSelectedPriceRange() {
		let (sut, interactor, _) = makeSUT()

		sut.reset()

		XCTAssertEqual(interactor.messages, [.handlePriceRangeReset(.init())])
	}

	func test_sliderValueChanged_slectingPriceRange() {
		let (sut, interactor, _) = makeSUT()
		sut.simulateAppearance()
		sut.display(viewModel: makeLoadViewModelWith(priceRange: .none, in: 0...500))

		sut.simulateSliderLowerValueChanged(to: 20)
		XCTAssertEqual(interactor.messages.last, .handleSelectingPriceRange(.init(priceRange: 20...500)))

		sut.simulateSliderUpperValueChanged(to: 30)
		XCTAssertEqual(interactor.messages.last, .handleSelectingPriceRange(.init(priceRange: 20...30)))
	}

	func test_sliderEditingDidEnd_selectsPriceRange() {
		let (sut, interactor, _) = makeSUT()
		sut.simulateAppearance()
		sut.display(viewModel: makeLoadViewModelWith(priceRange: .none, in: 0...500))

		sut.simulateSliderLowerEditingDidEnd(to: 20)
		XCTAssertEqual(interactor.messages.last, .handlePriceRangeSelection(.init(priceRange: 20...500)))

		sut.simulateSliderUpperEditingDidEnd(to: 30)
		XCTAssertEqual(interactor.messages.last, .handlePriceRangeSelection(.init(priceRange: 20...30)))
	}

	func test_display_rendersPriceRange() {
		let viewModel = makeLoadViewModelWith(priceRange: 100...200, in: 0...500)
		let (sut, _, _) = makeSUT()
		sut.simulateAppearance()

		sut.display(viewModel: viewModel)

		assertThat(sut, isRendering: viewModel.priceRangeViewModel)
	}

	func test_displayReset_rendersPriceRange() {
		let viewModel = makeResetViewModelWith(availablePriceRange: 0...500)
		let (sut, _, _) = makeSUT()
		sut.simulateAppearance()
		
		sut.display(viewModel: makeLoadViewModelWith(priceRange: 100...200, in: 0...500))
		sut.displayReset(viewModel: viewModel)

		assertThat(sut, isRendering: viewModel.priceRangeViewModel)
	}

	func test_displaySelecting_rendersSelectingPriceRange() {
		let (sut, _, _) = makeSUT()

		sut.displaySelecting(viewModel: .init(lowerValue: "US$150", upperValue: "US$200"))

		XCTAssertEqual(sut.lowerValueLabel.text, "US$150")
		XCTAssertEqual(sut.upperValueLabel.text, "US$200")
	}
	
	func test_displaySelect_notifiesDelegateWithSelectedPriceRange() {
		let (sut, _, delegate) = makeSUT()

		sut.displaySelect(viewModel: .init(priceRange: 150...200))

		XCTAssertEqual(delegate.messages, [.didSelectPriceRange(150...200)])
	}

	// MARK: - Helpers

	private func makeSUT() -> (
		sut: PriceRangeViewController,
		interactor: PriceRangeBusinessLogicSpy,
		delegate: PriceRangeDelegateSpy
	) {
		let interactor = PriceRangeBusinessLogicSpy()
		let delegate = PriceRangeDelegateSpy()
		let sut = PriceRangeViewController(delegate: delegate)
		sut.interactor = interactor
		return (sut, interactor, delegate)
	}

	private func makeLoadViewModelWith(
		priceRange: ClosedRange<Decimal>?,
		in availablePriceRange: ClosedRange<Decimal>,
		lowerValue: String = "lower",
		upperValue: String = "upper"
	) -> PriceRangeModels.FetchPriceRange.ViewModel {
		.init(
			priceRangeViewModel: .init(
				availablePriceRange: availablePriceRange,
				priceRange: priceRange ?? availablePriceRange,
				lowerValue: lowerValue,
				upperValue: upperValue
			)
		)
	}

	private func makeResetViewModelWith(
		availablePriceRange: ClosedRange<Decimal>,
		lowerValue: String = "lower",
		upperValue: String = "upper"
	) -> PriceRangeModels.PriceRangeReset.ViewModel {
		.init(
			priceRangeViewModel: .init(
				availablePriceRange: availablePriceRange,
				priceRange: availablePriceRange,
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
		case doFetchPriceRange(PriceRangeModels.FetchPriceRange.Request)
		case handlePriceRangeReset(PriceRangeModels.PriceRangeReset.Request)
		case handlePriceRangeSelection(PriceRangeModels.PriceRangeSelection.Request)
		case handleSelectingPriceRange(PriceRangeModels.SelectingPriceRange.Request)
	}

	private(set) var messages = [Message]()

	func doFetchPriceRange(request: PriceRangeModels.FetchPriceRange.Request) {
		messages.append(.doFetchPriceRange(request))
	}
	
	func handlePriceRangeReset(request: PriceRangeModels.PriceRangeReset.Request) {
		messages.append(.handlePriceRangeReset(request))
	}
	
	func handlePriceRangeSelection(request: PriceRangeModels.PriceRangeSelection.Request) {
		messages.append(.handlePriceRangeSelection(request))
	}
	
	func handleSelectingPriceRange(request: PriceRangeModels.SelectingPriceRange.Request) {
		messages.append(.handleSelectingPriceRange(request))
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

//
//  DestinationPickerPresenterTests.swift
//  HotelsDemoTests
//
//  Created by Denys Kotenko on 28/6/25.
//

import XCTest
import HotelsDemo

final class DestinationPickerPresenterTests: XCTestCase {
	func test_presentDestinations_displayDestinations() {
		let destination = makeDestination(label: "Mexico City")
		let (sut, viewController) = makeSUT()

		sut.presentDestinations(response: .init(destinations: [destination]))

		XCTAssertEqual(viewController.messages, [.displayDestinations(.init(destinations: ["Mexico City"]))])
	}

	func test_presentSelectedDestination_displaySelectedDestination() {
		let destination = makeDestination(label: "Mexico City")
		let (sut, viewController) = makeSUT()

		sut.presentSelectedDestination(response: .init(selected: destination))

		XCTAssertEqual(viewController.messages, [.displaySelectedDestination(.init(selected: destination))])
	}

	// MARK: - Helpers

	private func makeSUT() -> (
		sut: DestinationPickerPresenter,
		viewController: DestinationPickerDisplayLogicSpy
	) {
		let viewController = DestinationPickerDisplayLogicSpy()
		let sut = DestinationPickerPresenter()
		sut.viewController = viewController
		return (sut, viewController)
	}
}

final class DestinationPickerDisplayLogicSpy: DestinationPickerDisplayLogic {
	enum Message: Equatable {
		case displayDestinations(DestinationPickerModels.Search.ViewModel)
		case displaySelectedDestination(DestinationPickerModels.Select.ViewModel)
	}

	private(set) var messages = [Message]()

	func displayDestinations(viewModel: DestinationPickerModels.Search.ViewModel) {
		messages.append(.displayDestinations(viewModel))
	}
	
	func displaySelectedDestination(viewModel: DestinationPickerModels.Select.ViewModel) {
		messages.append(.displaySelectedDestination(viewModel))
	}
	
	func displaySearchError(viewModel: DestinationPickerModels.Search.ErrorViewModel) {

	}
	
	func hideSearchError() {

	}
}

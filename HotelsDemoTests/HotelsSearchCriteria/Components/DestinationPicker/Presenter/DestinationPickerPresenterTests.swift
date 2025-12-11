//
//  DestinationPickerPresenterTests.swift
//  HotelsDemoTests
//
//  Created by Denys Kotenko on 28/6/25.
//

import XCTest
import HotelsDemo

@MainActor
final class DestinationPickerPresenterTests: XCTestCase {
	func test_presentDestinations_displayDestinations() {
		let destination = makeDestination(
			name: "New York",
			country: "United States",
			cityName: "New York"
		)
		let (sut, viewController) = makeSUT()

		sut.presentDestinations(response: .init(destinations: [destination]))

		XCTAssertTrue(viewController.messages.contains(where: {
			$0 == .displayDestinations(.init(destinations: [.init(title: "New York", subtitle: "New York, United States")]))
		}))
	}

	func test_presentDestinations_hideSearchError() {
		let (sut, viewController) = makeSUT()

		sut.presentDestinations(response: .init(destinations: [anyDestination()]))

		XCTAssertTrue(viewController.messages.contains(where: { $0 == .hideSearchError }))
	}

	func test_presentSelectedDestination_displaySelectedDestination() {
		let destination = anyDestination()
		let (sut, viewController) = makeSUT()

		sut.presentSelectedDestination(response: .init(selected: destination))

		XCTAssertEqual(viewController.messages, [.displaySelectedDestination(.init(selected: destination))])
	}

	func test_presentSearchError_displaySearchError() {
		let error = TestError("error message")
		let (sut, viewController) = makeSUT()
		
		sut.presentSearchError(error)

		XCTAssertEqual(viewController.messages, [.displaySearchError(.init(message: "error message"))])
	}

	// MARK: - Helpers

	private func makeSUT() -> (
		sut: DestinationPickerPresenter,
		viewController: DestinationPickerDisplayLogicSpy
	) {
		let viewController = DestinationPickerDisplayLogicSpy()
		let sut = DestinationPickerPresenter(
			viewController: viewController
		)
		return (sut, viewController)
	}
}

final class DestinationPickerDisplayLogicSpy: DestinationPickerDisplayLogic {
	enum Message: Equatable {
		case displayDestinations(DestinationPickerModels.Search.ViewModel)
		case displaySelectedDestination(DestinationPickerModels.DestinationSelection.ViewModel)
		case displaySearchError(DestinationPickerModels.Search.ErrorViewModel)
		case hideSearchError
	}

	private(set) var messages = [Message]()

	func displayDestinations(viewModel: DestinationPickerModels.Search.ViewModel) {
		messages.append(.displayDestinations(viewModel))
	}
	
	func displaySelectedDestination(viewModel: DestinationPickerModels.DestinationSelection.ViewModel) {
		messages.append(.displaySelectedDestination(viewModel))
	}
	
	func displaySearchError(viewModel: DestinationPickerModels.Search.ErrorViewModel) {
		messages.append(.displaySearchError(viewModel))
	}
	
	func hideSearchError() {
		messages.append(.hideSearchError)
	}
}

//
//  MainPresenterTests.swift
//  HotelsDemoTests
//

import XCTest
import HotelsDemo

@MainActor
final class MainPresenterTests: XCTestCase {
	func test_init_doesNotDisplaySearch() {
		let (_, viewController) = makeSUT()

		XCTAssertTrue(viewController.messages.isEmpty)
	}

	func test_presentSearch_displaysSearchWithCriteria() {
		let criteria = anySearchCriteria()
		let (sut, viewController) = makeSUT()

		sut.presentSearch(response: .init(criteria: criteria))

		XCTAssertEqual(viewController.messages, [.displaySearch(.init(criteria: criteria))])
	}

	// MARK: - Helpers

	private func makeSUT() -> (
		sut: MainPresenter,
		viewController: MainDisplayLogicSpy
	) {
		let viewController = MainDisplayLogicSpy()
		let sut = MainPresenter(viewController: viewController)
		trackForMemoryLeaks(viewController)
		trackForMemoryLeaks(sut)
		return (sut, viewController)
	}
}

final class MainDisplayLogicSpy: MainDisplayLogic {
	enum Message: Equatable {
		case displaySearch(MainModels.Search.ViewModel)
	}

	private(set) var messages = [Message]()

	func displaySearch(viewModel: MainModels.Search.ViewModel) {
		messages.append(.displaySearch(viewModel))
	}
}

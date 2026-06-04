//
//  MainInteractorTests.swift
//  HotelsDemoTests
//

import XCTest
import HotelsDemo

@MainActor
final class MainInteractorTests: XCTestCase {
	func test_init_doesNotPresentSearch() {
		let (_, presenter) = makeSUT()

		XCTAssertTrue(presenter.messages.isEmpty)
	}

	func test_handleSearch_presentsSearchWithCriteria() {
		let criteria = anySearchCriteria()
		let (sut, presenter) = makeSUT()

		sut.handleSearch(request: .init(criteria: criteria))

		XCTAssertEqual(presenter.messages, [.presentSearch(.init(criteria: criteria))])
	}

	// MARK: - Helpers

	private func makeSUT() -> (
		sut: MainInteractor,
		presenter: MainPresentationLogicSpy
	) {
		let presenter = MainPresentationLogicSpy()
		let sut = MainInteractor(presenter: presenter)
		trackForMemoryLeaks(presenter)
		trackForMemoryLeaks(sut)
		return (sut, presenter)
	}
}

final class MainPresentationLogicSpy: MainPresentationLogic {
	enum Message: Equatable {
		case presentSearch(MainModels.Search.Response)
	}

	private(set) var messages = [Message]()

	func presentSearch(response: MainModels.Search.Response) {
		messages.append(.presentSearch(response))
	}
}

//
//  MainViewControllerTests.swift
//  HotelsDemoTests
//

import XCTest
import HotelsDemo

@MainActor
final class MainViewControllerTests: XCTestCase {
	func test_viewDidLoad_addsSearchCriteriaAsChild() {
		let (sut, _, _, searchCriteria) = makeSUT()

		XCTAssertNil(searchCriteria.parent, "Expected no parent before appearance")

		sut.simulateAppearance()

		XCTAssertEqual(objectID(searchCriteria.parent), objectID(sut))
		XCTAssertTrue(sut.children.contains(searchCriteria))
	}

	func test_didRequestSearch_handlesSearchWithCriteria() {
		let criteria = anySearchCriteria()
		let (sut, interactor, _, _) = makeSUT()

		sut.didRequestSearch(with: criteria)

		XCTAssertEqual(interactor.messages, [.handleSearch(.init(criteria: criteria))])
	}

	func test_displaySearch_routesToSearchWithCriteria() {
		let criteria = anySearchCriteria()
		let (sut, _, router, _) = makeSUT()

		sut.displaySearch(viewModel: .init(criteria: criteria))

		XCTAssertEqual(router.messages, [.routeToSearch(.init(criteria: criteria))])
	}

	// MARK: - Helpers

	private func makeSUT() -> (
		sut: MainViewController,
		interactor: MainBusinessLogicSpy,
		router: MainRoutingLogicSpy,
		searchCriteria: UIViewController
	) {
		let interactor = MainBusinessLogicSpy()
		let router = MainRoutingLogicSpy()
		let searchCriteria = UIViewController()
		let sut = MainViewController(
			searchCriteriaViewController: searchCriteria,
			interactor: interactor,
			router: router
		)
		trackForMemoryLeaks(interactor)
		trackForMemoryLeaks(router)
		trackForMemoryLeaks(searchCriteria)
		trackForMemoryLeaks(sut)
		return (sut, interactor, router, searchCriteria)
	}
}

final class MainBusinessLogicSpy: MainBusinessLogic {
	enum Message: Equatable {
		case handleSearch(MainModels.Search.Request)
	}

	private(set) var messages = [Message]()

	func handleSearch(request: MainModels.Search.Request) {
		messages.append(.handleSearch(request))
	}
}

final class MainRoutingLogicSpy: MainRoutingLogic {
	enum Message: Equatable {
		case routeToSearch(MainModels.Search.ViewModel)
	}

	private(set) var messages = [Message]()

	func routeToSearch(viewModel: MainModels.Search.ViewModel) {
		messages.append(.routeToSearch(viewModel))
	}
}

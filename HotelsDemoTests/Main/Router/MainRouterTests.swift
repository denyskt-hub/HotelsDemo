//
//  MainRouterTests.swift
//  HotelsDemoTests
//

import XCTest
import HotelsDemo

@MainActor
final class MainRouterTests: XCTestCase {
	func test_routeToSearch_buildsSearchWithCriteria() {
		let criteria = anySearchCriteria()
		let (sut, factory, _) = makeSUT()

		sut.routeToSearch(viewModel: .init(criteria: criteria))

		XCTAssertEqual(factory.messages, [.makeSearch(criteria)])
	}

	func test_routeToSearch_showsSearchOnScene() {
		let (sut, factory, scene) = makeSUT()

		sut.routeToSearch(viewModel: .init(criteria: anySearchCriteria()))

		XCTAssertEqual(scene.shownVC, factory.stub)
		XCTAssertNil(scene.presentedVC, "Expected search to be shown, not presented")
	}

	func test_routeToSearch_showsSearchBuiltByFactory() {
		let (sut, factory, scene) = makeSUT()

		sut.routeToSearch(viewModel: .init(criteria: anySearchCriteria()))

		XCTAssertEqual(objectID(scene.shownVC), objectID(factory.stub))
	}

	// MARK: - Helpers

	private func makeSUT() -> (
		sut: MainRouter,
		factory: HotelsSearchFactoryStub,
		scene: MainViewControllerSpy
	) {
		let factory = HotelsSearchFactoryStub()
		let scene = MainViewControllerSpy()
		let sut = MainRouter(
			searchFactory: factory,
			scene: scene
		)
		trackForMemoryLeaks(factory)
		trackForMemoryLeaks(scene)
		trackForMemoryLeaks(sut)
		return (sut, factory, scene)
	}
}

final class MainViewControllerSpy: UIViewController, MainScene {
	var shownVC: UIViewController?
	var presentedVC: UIViewController?

	override func show(_ vc: UIViewController, sender: Any?) {
		shownVC = vc
	}

	override func present(_ viewControllerToPresent: UIViewController, animated: Bool, completion: (() -> Void)? = nil) {
		presentedVC = viewControllerToPresent
	}
}

@MainActor
final class HotelsSearchFactoryStub: HotelsSearchFactory {
	enum Message: Equatable {
		case makeSearch(HotelsSearchCriteria)
	}

	var stub = UIViewController()

	private(set) var messages = [Message]()

	func makeSearch(with criteria: HotelsSearchCriteria) -> UIViewController {
		messages.append(.makeSearch(criteria))
		return stub
	}
}

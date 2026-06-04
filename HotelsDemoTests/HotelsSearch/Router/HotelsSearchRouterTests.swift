//
//  HotelsSearchRouterTests.swift
//  HotelsDemoTests
//

import XCTest
import HotelsDemo

@MainActor
final class HotelsSearchRouterTests: XCTestCase {
	func test_routeToHotelFiltersPicker_buildsPickerWithSceneAsDelegate() {
		let filters = anyHotelFilters()
		let (sut, factory, viewController) = makeSUT()

		sut.routeToHotelFiltersPicker(filters)

		XCTAssertEqual(factory.messages, [
			.makeHotelFiltersPicker(filters, objectID(viewController))
		])
	}

	func test_routeToHotelFiltersPicker_presentsPickerEmbeddedInNavigationController() {
		let (sut, factory, viewController) = makeSUT()

		sut.routeToHotelFiltersPicker(anyHotelFilters())

		let presented = viewController.presentedVC as? UINavigationController
		XCTAssertNotNil(presented, "Expected picker embedded in a navigation controller")
		XCTAssertEqual(presented?.viewControllers.first, factory.stub)
	}

	// MARK: - Helpers

	private func makeSUT() -> (
		sut: HotelsSearchRouter,
		factory: HotelFiltersPickerFactoryStub,
		viewController: SearchViewControllerSpy
	) {
		let factory = HotelFiltersPickerFactoryStub()
		let viewController = SearchViewControllerSpy()
		let sut = HotelsSearchRouter(
			hotelFiltersPickerFactory: factory,
			scene: viewController
		)
		trackForMemoryLeaks(factory)
		trackForMemoryLeaks(viewController)
		trackForMemoryLeaks(sut)
		return (sut, factory, viewController)
	}
}

final class SearchViewControllerSpy: UIViewController, HotelsSearchScene {
	var presentedVC: UIViewController?

	override func present(_ viewControllerToPresent: UIViewController, animated: Bool, completion: (() -> Void)? = nil) {
		presentedVC = viewControllerToPresent
	}

	func didSelectFilters(_ filters: HotelFilters) {
		// No-op — not needed in this test case
	}
}

@MainActor
final class HotelFiltersPickerFactoryStub: HotelFiltersPickerFactory {
	enum Message: Equatable {
		case makeHotelFiltersPicker(HotelFilters, ObjectIdentifier?)
	}

	var stub = UIViewController()

	private(set) var messages = [Message]()

	func makeHotelFiltersPicker(filters: HotelFilters, delegate: HotelFiltersPickerDelegate) -> UIViewController {
		messages.append(.makeHotelFiltersPicker(filters, objectID(delegate)))
		return stub
	}
}

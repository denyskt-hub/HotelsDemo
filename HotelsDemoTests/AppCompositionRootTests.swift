//
//  AppCompositionRootTests.swift
//  HotelsDemoTests
//

import XCTest
@testable import HotelsDemo

@MainActor
final class AppCompositionRootTests: XCTestCase {
	func test_compose_buildsNavigationRootWithMainScene() {
		let sut = makeSUT()

		let root = sut.compose()

		let navigation = root as? UINavigationController
		XCTAssertNotNil(navigation, "Expected the app root to be a navigation controller")
		XCTAssertNotNil(navigation?.viewControllers.first, "Expected the main scene to be installed")
	}

	func test_compose_composedGraphDeallocates() {
		let sut = makeSUT()

		// `trackForMemoryLeaks` asserts at teardown (with a grace period for
		// the boot task started by the criteria scene), once the local strong
		// reference below is gone.
		let root = sut.compose()
		trackForMemoryLeaks(root)
	}

	// MARK: - Helpers

	/// The composition root itself is an app-lifetime object: its factory
	/// closures intentionally reference it back, so the root is NOT
	/// leak-tracked here — only the graphs it composes are.
	private func makeSUT() -> AppCompositionRoot {
		AppCompositionRoot(environment: testEnvironment())
	}

	private func testEnvironment() -> Environment.Config {
		Environment.Config(
			apiKey: "test-api-key",
			apiHost: "api.example.com",
			baseURL: URL(string: "https://api.example.com")!
		)
	}
}

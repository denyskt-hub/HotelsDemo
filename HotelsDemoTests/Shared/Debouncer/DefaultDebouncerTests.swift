//
//  DefaultDebouncerTests.swift
//  HotelsDemoTests
//
//  Created by Denys Kotenko on 28/6/25.
//

import XCTest
import HotelsDemo

final class DefaultDebouncerTests: XCTestCase {
	func test_debounce_callsActionAfterDelay() {
		let sut = makeSUT(delay: 0.05)

		let exp = expectation(description: "Wait for debounce")

		var called = false
		sut.execute {
			called = true
			exp.fulfill()
		}

		wait(for: [exp], timeout: 0.2)
		XCTAssertTrue(called)
	}

	// MARK: - Helpers

	private func makeSUT(
		delay: TimeInterval,
		queue: DispatchQueue = .main
	) -> DefaultDebouncer {
		DefaultDebouncer(
			delay: delay,
			queue: queue
		)
	}
}

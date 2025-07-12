//
//  DefaultDebouncerTests.swift
//  HotelsDemoTests
//
//  Created by Denys Kotenko on 28/6/25.
//

import XCTest
import HotelsDemo

final class DefaultDebouncerTests: XCTestCase {
	func test_execute_callsActionAfterDelay() {
		let sut = makeSUT(delay: 0.01)

		let exp = expectation(description: "Wait for debounce")

		var called = false
		sut.execute {
			called = true
			exp.fulfill()
		}

		wait(for: [exp], timeout: 0.1)
		XCTAssertTrue(called)
	}

	func test_execute_cancelsPreviousCall() {
		let sut = makeSUT(delay: 0.01)

		let exp = expectation(description: "Wait for debounce")

		var callsCount = 0
		sut.execute {
			callsCount += 1
		}

		sut.execute {
			callsCount += 1
			exp.fulfill()
		}

		wait(for: [exp], timeout: 0.1)
		XCTAssertEqual(callsCount, 1)
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

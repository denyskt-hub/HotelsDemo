//
//  DefaultDebouncerTests.swift
//  HotelsDemoTests
//
//  Created by Denys Kotenko on 28/6/25.
//

import XCTest
import HotelsDemo
import Synchronization

@MainActor
final class DefaultDebouncerTests: XCTestCase {
	func test_execute_callsActionAfterDelay() {
		let sut = makeSUT(delay: 0.01)

		let exp = expectation(description: "Wait for debounce")

		let called = Mutex<Bool>(false)
		sut.execute {
			called.withLock { $0 = true}
			exp.fulfill()
		}

		wait(for: [exp], timeout: 0.1)
		XCTAssertTrue(called.withLock({ $0 }))
	}

	func test_execute_cancelsPreviousCall() {
		let sut = makeSUT(delay: 0.01)

		let exp = expectation(description: "Wait for debounce")

		let callsCount = Mutex<Int>(0)
		sut.execute {
			callsCount.withLock { $0 += 1 }
		}

		sut.execute {
			callsCount.withLock { $0 += 1 }
			exp.fulfill()
		}

		wait(for: [exp], timeout: 0.1)
		XCTAssertEqual(callsCount.withLock({ $0 }), 1)
	}

	// MARK: - Helpers

	private func makeSUT(delay: TimeInterval) -> DefaultDebouncer {
		DefaultDebouncer(delay: delay)
	}
}

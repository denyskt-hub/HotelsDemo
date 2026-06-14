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

	func test_asyncExecute_callsActionAfterDelay() {
		let sut = makeSUT(delay: 0.01)

		let exp = expectation(description: "Wait for debounce")

		let called = Mutex<Bool>(false)
		sut.asyncExecute {
			called.withLock { $0 = true }
			exp.fulfill()
		}

		wait(for: [exp], timeout: 0.1)
		XCTAssertTrue(called.withLock({ $0 }))
	}

	func test_asyncExecute_cancelsPreviousCalls_firesOnlyLast() {
		let sut = makeSUT(delay: 0.01)

		let exp = expectation(description: "Wait for debounce")

		let firedIDs = Mutex<[Int]>([])
		for id in 1...3 {
			sut.asyncExecute {
				firedIDs.withLock { $0.append(id) }
				if id == 3 { exp.fulfill() }
			}
		}

		wait(for: [exp], timeout: 0.1)
		XCTAssertEqual(firedIDs.withLock({ $0 }), [3], "Only the last scheduled action should fire")
	}

	// MARK: - Helpers

	private func makeSUT(delay: TimeInterval) -> DefaultDebouncer {
		let sut = DefaultDebouncer(delay: delay)
		trackForMemoryLeaks(sut)
		return sut
	}
}

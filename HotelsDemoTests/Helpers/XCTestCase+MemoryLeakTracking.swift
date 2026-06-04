//
//  XCTestCase+MemoryLeakTracking.swift
//  HotelsDemoTests
//

import XCTest

extension XCTestCase {
	func trackForMemoryLeaks(
		_ instance: AnyObject,
		file: StaticString = #filePath,
		line: UInt = #line
	) {
		let ref = WeakRef(instance)
		addTeardownBlock {
			// In-flight tasks may hold the instance for an instant after the
			// test ends (e.g. a `Task` releasing its captured `self` right
			// after its final delegate callback). Grant a short grace period:
			// a genuine retain cycle never deallocates, so this only prevents
			// scheduler-dependent flakiness — it cannot hide real leaks.
			var attempts = 0
			while ref.value != nil, attempts < 20 {
				attempts += 1
				await Task.yield()
				if ref.value != nil {
					try? await Task.sleep(nanoseconds: 25_000_000)
				}
			}

			XCTAssertNil(
				ref.value,
				"Instance should have been deallocated. Potential memory leak.",
				file: file,
				line: line
			)
		}
	}
}

/// Sendable box holding only a `weak` reference.
///
/// `@unchecked Sendable` is sound here: weak references are atomic in the Swift runtime,
/// and XCTest runs teardown blocks strictly after the test method finishes,
/// so `value` is never accessed concurrently.
private final class WeakRef: @unchecked Sendable {
	private(set) weak var value: AnyObject?

	init(_ value: AnyObject) {
		self.value = value
	}
}

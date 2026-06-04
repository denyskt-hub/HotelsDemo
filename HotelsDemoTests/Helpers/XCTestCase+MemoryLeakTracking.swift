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

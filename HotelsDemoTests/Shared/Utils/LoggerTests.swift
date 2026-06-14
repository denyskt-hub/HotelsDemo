//
//  LoggerTests.swift
//  HotelsDemoTests
//
//  Created by Denys Kotenko on 14/6/26.
//

import XCTest
import Synchronization
@testable import HotelsDemo

final class LoggerTests: XCTestCase {

	// MARK: - C1: laziness

	func test_log_doesNotEvaluateMessage_whenFilteredOut() {
		let evaluations = EvaluationCounter()
		// debug level under a tag that is not enabled → filtered out.
		let sut = LoggerEngine(configuration: .init(level: .debug, enabledTags: []), sink: CollectingLogSink())

		sut.log(message(countingInto: evaluations), level: .debug, tag: .custom("disabled"))

		XCTAssertEqual(evaluations.count, 0, "@autoclosure must stay lazy: a filtered-out line must not build its (possibly expensive) message")
	}

	func test_log_evaluatesMessageOnce_whenEnabled() async {
		let evaluations = EvaluationCounter()
		let sink = CollectingLogSink()
		let sut = LoggerEngine(configuration: .default, sink: sink)

		sut.log(message(countingInto: evaluations), level: .debug, tag: .general)

		XCTAssertEqual(evaluations.count, 1)
		await sink.waitForLines(1)
		XCTAssertEqual(sink.lines.count, 1)
	}

	// MARK: - C3a: error/warning bypass the tag filter

	func test_log_errorBypassesTagFilter_andKeepsInjectedTag() async {
		let sink = CollectingLogSink()
		// No tags enabled at all — a debug line would be dropped.
		let sut = LoggerEngine(configuration: .init(level: .debug, enabledTags: []), sink: sink)

		sut.log({ "boom" }, level: .error, tag: .custom("image"))

		await sink.waitForLines(1)
		let line = try? XCTUnwrap(sink.lines.first)
		XCTAssertEqual(sink.lines.count, 1, "errors must print even when their tag is disabled")
		XCTAssertTrue(line?.contains("boom") == true)
		XCTAssertTrue(line?.contains("image") == true, "the injected tag must be preserved in the output")
	}

	func test_log_debugUnderDisabledTag_isFilteredOut() {
		let evaluations = EvaluationCounter()
		let sut = LoggerEngine(configuration: .init(level: .debug, enabledTags: []), sink: CollectingLogSink())

		sut.log(message(countingInto: evaluations), level: .debug, tag: .custom("image"))

		XCTAssertEqual(evaluations.count, 0)
	}

	func test_log_respectsMinimumLevel() {
		let evaluations = EvaluationCounter()
		let sut = LoggerEngine(configuration: .init(level: .warning, enabledTags: [.general]), sink: CollectingLogSink())

		sut.log(message(countingInto: evaluations), level: .info, tag: .general)

		XCTAssertEqual(evaluations.count, 0, "a line below the minimum level must be filtered out")
	}

	// MARK: - C2: ordering

	func test_log_preservesEmissionOrder() async {
		let sink = CollectingLogSink()
		let sut = LoggerEngine(configuration: .default, sink: sink)

		let count = 50
		for index in 0..<count {
			sut.log({ "line-\(index)" }, level: .debug, tag: .general)
		}

		await sink.waitForLines(count)
		XCTAssertEqual(sink.lines.count, count)
		for (index, line) in sink.lines.enumerated() {
			XCTAssertTrue(line.contains("line-\(index)"), "lines must print in emission order")
		}
	}

	// MARK: - Helpers

	/// A message closure that records how many times it is evaluated — used to
	/// prove `@autoclosure` laziness without depending on the (async) output.
	private func message(countingInto counter: EvaluationCounter) -> () -> String {
		{
			counter.increment()
			return "expensive message"
		}
	}
}

/// Reference-type evaluation counter (a `Mutex` is `~Copyable` and can't be
/// captured by a message closure directly).
final class EvaluationCounter: Sendable {
	private let value = Mutex(0)

	var count: Int {
		value.withLock { $0 }
	}

	func increment() {
		value.withLock { $0 += 1 }
	}
}

// MARK: - Test sink

/// Collects emitted lines and lets a test await delivery, since output is
/// drained asynchronously by the engine's consumer.
final class CollectingLogSink: LogSink {
	private struct State {
		var lines: [String] = []
		var waiters: [(target: Int, continuation: CheckedContinuation<Void, Never>)] = []
	}

	private let state = Mutex(State())

	var lines: [String] {
		state.withLock { $0.lines }
	}

	func write(_ line: String) {
		let resumable: [CheckedContinuation<Void, Never>] = state.withLock { state in
			state.lines.append(line)
			let ready = state.waiters.filter { state.lines.count >= $0.target }
			state.waiters.removeAll { state.lines.count >= $0.target }
			return ready.map(\.continuation)
		}
		resumable.forEach { $0.resume() }
	}

	func waitForLines(_ count: Int) async {
		await withCheckedContinuation { continuation in
			let alreadyReached = state.withLock { state -> Bool in
				guard state.lines.count < count else { return true }
				state.waiters.append((count, continuation))
				return false
			}
			if alreadyReached {
				continuation.resume()
			}
		}
	}
}

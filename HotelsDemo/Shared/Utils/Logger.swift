//
//  Logger.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 19/7/25.
//

import Foundation
import Synchronization

// MARK: - Output sink

/// Destination for formatted log lines. Injectable so tests can collect
/// output instead of printing it.
protocol LogSink: Sendable {
	func write(_ line: String)
}

struct PrintLogSink: LogSink {
	func write(_ line: String) {
		print(line)
	}
}

// MARK: - Engine

/// The logging core. Holds configuration behind a `Mutex` (read synchronously,
/// so `shouldLog` and `@autoclosure` laziness stay synchronous) and serializes
/// output through a single ordered consumer. Instantiable so tests run against
/// an isolated engine instead of shared global state.
final class LoggerEngine: Sendable {
	private let configuration: Mutex<LoggerConfiguration>
	private let continuation: AsyncStream<String>.Continuation
	private let consumer: Task<Void, Never>

	init(configuration: LoggerConfiguration = .default, sink: LogSink = PrintLogSink()) {
		self.configuration = Mutex(configuration)
		let (stream, continuation) = AsyncStream<String>.makeStream()
		self.continuation = continuation
		// `yield` preserves submission order and a single consumer drains the
		// stream, so lines print in the order emitted without each call
		// spawning its own task.
		self.consumer = Task {
			for await line in stream {
				sink.write(line)
			}
		}
	}

	deinit {
		continuation.finish()
	}

	func log(
		_ message: () -> String,
		level: LogLevel,
		tag: LogTag,
		file: StaticString = #filePath,
		function: String = #function,
		line: UInt = #line
	) {
		let configuration = configuration.withLock { $0 }
		// Gating is synchronous so `@autoclosure` stays lazy: the (possibly
		// expensive) message is built only when the line will actually print.
		guard Self.shouldLog(configuration, level, tag) else { return }

		let location = Self.location(file: file, function: function, line: line)
		continuation.yield(Self.format(message(), level: level, tag: tag, location: location))
	}

	func configure(_ configuration: LoggerConfiguration) {
		self.configuration.withLock { $0 = configuration }
	}

	func setMinimumLogLevel(_ level: LogLevel) {
		configuration.withLock { $0.level = level }
	}

	func enableTag(_ tag: LogTag) {
		configuration.withLock { $0.enabledTags.insert(tag) }
	}

	func disableTag(_ tag: LogTag) {
		configuration.withLock { $0.enabledTags.remove(tag) }
	}

	func disableAllLogs() {
		configuration.withLock { $0.level = .none }
	}

	private static func shouldLog(_ configuration: LoggerConfiguration, _ level: LogLevel, _ tag: LogTag) -> Bool {
		#if DEBUG
		guard level.priority >= configuration.level.priority else { return false }
		// Errors and warnings bypass the tag filter: a disabled subsystem tag
		// must never silence them — you always want to see failures.
		if level.priority >= LogLevel.warning.priority { return true }
		return configuration.enabledTags.contains(tag)
		#else
		return false
		#endif
	}

	private static func format(_ message: String, level: LogLevel, tag: LogTag, location: String) -> String {
		"[\(level.rawValue)] [\(tag.rawValue)] \(location)➝ \(message)"
	}

	private static func location(file: StaticString, function: String, line: UInt) -> String {
		let fileString = String(describing: file)
		guard !fileString.isEmpty else {
			return ""
		}
		let fileName = fileString.components(separatedBy: "/").last ?? "Unknown"
		return "\(fileName):\(line) \(function) "
	}
}

// MARK: - Static facade

public enum Logger {
	private static let shared = LoggerEngine()

	public static func log(
		_ message: @autoclosure () -> String,
		level: LogLevel = .debug,
		tag: LogTag = .general,
		file: StaticString = #filePath,
		function: String = #function,
		line: UInt = #line
	) {
		// `message` is forwarded as a non-escaping closure, so it stays unevaluated
		// until the engine decides the line will print.
		shared.log(message, level: level, tag: tag, file: file, function: function, line: line)
	}

	public static func configure(_ configuration: LoggerConfiguration) {
		shared.configure(configuration)
	}

	public static func setMinimumLogLevel(_ level: LogLevel) {
		shared.setMinimumLogLevel(level)
	}

	public static func enableTag(_ tag: LogTag) {
		shared.enableTag(tag)
	}

	public static func disableTag(_ tag: LogTag) {
		shared.disableTag(tag)
	}

	public static func disableAllLogs() {
		shared.disableAllLogs()
	}
}

// MARK: - Types

public enum LogLevel: String, Sendable {
	case debug = "🔍 DEBUG"
	case info = "ℹ️ INFO"
	case warning = "⚠️ WARNING"
	case error = "❌ ERROR"
	case none = ""

	public var priority: Int {
		switch self {
		case .debug:
			return 0
		case .info:
			return 1
		case .warning:
			return 2
		case .error:
			return 3
		case .none:
			return 99
		}
	}
}

public enum LogTag: Hashable, Sendable {
	case general
	case networking
	case custom(String)

	public var rawValue: String {
		switch self {
		case .general: return "general"
		case .networking: return "networking"
		case .custom(let value): return value
		}
	}
}

public struct LoggerConfiguration: Sendable {
	var level: LogLevel
	var enabledTags: Set<LogTag>

	public static var `default`: LoggerConfiguration {
		.init(
			level: .debug,
			enabledTags: [.general, .networking]
		)
	}
}

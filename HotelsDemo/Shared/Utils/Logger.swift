//
//  Logger.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 19/7/25.
//

import Foundation

// MARK: - Logger facade backed by LoggerActor
public struct Logger {
	private static let actor = LoggerActor()

	public static func configure(_ configuration: LoggerConfiguration) {
		Task { await actor.setConfiguration(configuration) }
	}

	public static func log(
		_ message: @autoclosure () -> String,
		level: LogLevel = .debug,
		tag: LogTag = .general,
		file: StaticString = #filePath,
		function: String = #function,
		line: UInt = #line
	) {
		let msg = message()
		Task {
			await actor.log(
				msg,
				level: level,
				tag: tag,
				file: file,
				function: function,
				line: line
			)
		}
	}
}

// MARK: - Actor implementation
private actor LoggerActor {
	private var configuration: LoggerConfiguration = .default

	func setConfiguration(_ configuration: LoggerConfiguration) {
		self.configuration = configuration
	}

	func getConfiguration() -> LoggerConfiguration {
		configuration
	}

	func setMinimumLogLevel(_ level: LogLevel) {
		configuration.level = level
	}

	func enableTag(_ tag: LogTag) {
		configuration.enabledTags.insert(tag)
	}

	func disableTag(_ tag: LogTag) {
		configuration.enabledTags.remove(tag)
	}

	func disableAllLogs() {
		configuration.level = .none
	}

	func log(
		_ message: String,
		level: LogLevel,
		tag: LogTag,
		file: StaticString = #filePath,
		function: String = #function,
		line: UInt = #line
	) {
		guard shouldLog(configuration, level, tag) else { return }

		if String(describing: file).isEmpty {
			print("[\(level.rawValue)] [\(tag.rawValue)] ➝ \(message)")
		} else {
			let fileName = String(describing: file).components(separatedBy: "/").last ?? "Unknown"
			print("[\(level.rawValue)] [\(tag.rawValue)] \(fileName):\(line) \(function) ➝ \(message)")
		}
	}

	private func shouldLog(_ configuration: LoggerConfiguration, _ level: LogLevel, _ tag: LogTag) -> Bool {
		#if DEBUG
		level.priority >= configuration.level.priority && configuration.enabledTags.contains(tag)
		#else
		false
		#endif
	}
}

// MARK: - Convenience configuration helpers on facade
public extension Logger {
	static func setMinimumLogLevel(_ level: LogLevel) {
		Task { await actor.setMinimumLogLevel(level) }
	}

	static func enableTag(_ tag: LogTag) {
		Task { await actor.enableTag(tag) }
	}

	static func disableTag(_ tag: LogTag) {
		Task { await actor.disableTag(tag) }
	}

	static func disableAllLogs() {
		Task { await actor.disableAllLogs() }
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

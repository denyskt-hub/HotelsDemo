//
//  Logger.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 19/7/25.
//

import Foundation

public struct Logger {
	private static let queue = DispatchQueue(label: "\(Logger.self)Queue")

	private static var _configuration = LoggerConfiguration.default
	public static var configuration: LoggerConfiguration {
		get { queue.sync { _configuration } }
		set { queue.sync { _configuration = newValue } }
	}

	public static func log(
		_ message: @autoclosure () -> String,
		level: LogLevel = .debug,
		tag: LogTag = .general,
		file: StaticString = #filePath,
		function: String = #function,
		line: UInt = #line
	) {
		guard shouldLog(level, tag) else { return }
		let evaluatedMessage = message()

		queue.async {
			let fileName = String(describing: file).components(separatedBy: "/").last ?? "Unknown"
			print("[\(level.rawValue)] [\(tag.rawValue)] \(fileName):\(line) \(function) ➝ \(evaluatedMessage)")
		}
	}

	public static func log(
		_ message: @autoclosure () -> String,
		level: LogLevel = .debug,
		tag: LogTag = .general
	) {
		guard shouldLog(level, tag) else { return }
		let evaluatedMessage = message()

		queue.async {
			print("[\(level.rawValue)] [\(tag.rawValue)] ➝ \(evaluatedMessage)")
		}
	}

	private static func shouldLog(_ level: LogLevel, _ tag: LogTag) -> Bool {
		#if DEBUG
		level.priority >= configuration.level.priority && configuration.enabledTags.contains(tag)
		#else
		false
		#endif
	}
}

public extension Logger {
	static func setMinimumLogLevel(_ level: LogLevel) {
		var config = configuration
		config.level = level
		configuration = config
	}
}

public extension Logger {
	static func enableTag(_ tag: LogTag) {
		var config = configuration
		config.enabledTags.insert(tag)
		configuration = config
	}

	static func disableTag(_ tag: LogTag) {
		var config = configuration
		config.enabledTags.remove(tag)
		configuration = config
	}

	static func disableAllLogs() {
		var config = configuration
		config.level = .none
		configuration = config
	}
}

public enum LogLevel: String {
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

public enum LogTag: Hashable {
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

public struct LoggerConfiguration {
	var level: LogLevel
	var enabledTags: Set<LogTag>

	public static var `default`: LoggerConfiguration {
		.init(
			level: .debug,
			enabledTags: [.general, .networking]
		)
	}
}

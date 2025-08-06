//
//  Logger.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 19/7/25.
//

import Foundation

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

public struct Logger {
	public static var level: LogLevel = .debug
	public static var enabledTags: Set<LogTag> = [.general, .networking]

	public static func log(
		_ message: @autoclosure () -> String,
		level: LogLevel = .debug,
		tag: LogTag = .general,
		file: StaticString = #filePath,
		function: String = #function,
		line: UInt = #line
	) {
		guard shouldLog(level, tag) else { return }

		let fileName = String(describing: file).components(separatedBy: "/").last ?? "Unknown"
		print("[\(level.rawValue)] [\(tag)] \(fileName):\(line) \(function) ➝ \(message())")
	}

	public static func log(
		_ message: @autoclosure () -> String,
		level: LogLevel = .debug,
		tag: LogTag = .general
	) {
		guard shouldLog(level, tag) else { return }

		print("[\(level.rawValue)] [\(tag)] ➝ \(message())")
	}

	private static func shouldLog(_ level: LogLevel, _ tag: LogTag) -> Bool {
		#if DEBUG
		level.priority >= Self.level.priority && enabledTags.contains(tag)
		#else
		false
		#endif
	}
}

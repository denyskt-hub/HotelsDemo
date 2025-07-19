//
//  Logger.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 19/7/25.
//

import Foundation

public enum LogLevel: String {
	case debug = "DEBUG"
	case info = "INFO"
	case warning = "WARNING"
	case error = "ERROR"
}

public struct Logger {
	public static func log(
		_ message: String,
		level: LogLevel = .debug,
		file: StaticString = #filePath,
		function: String = #function,
		line: UInt = #line
	) {
		#if DEBUG
		let fileName = String(describing: file).components(separatedBy: "/").last ?? "Unknown"
		print("[\(level.rawValue)] \(fileName):\(line) \(function) ➝ \(message)")
		#endif
	}
}

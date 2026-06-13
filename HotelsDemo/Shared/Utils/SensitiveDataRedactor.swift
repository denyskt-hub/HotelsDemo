//
//  SensitiveDataRedactor.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 14/6/26.
//

import Foundation

/// Redacts sensitive values from data destined for logs — headers, URL query
/// parameters, and JSON bodies. Centralized so every log path applies the same
/// rule instead of each call site inventing its own partial redaction.
enum SensitiveDataRedactor {
	static let redactionMark = "***"

	private static let sensitiveKeywords = [
		"authorization", "api-key", "apikey", "token",
		"secret", "credential", "password", "cookie"
	]

	static func isSensitive(_ key: String) -> Bool {
		let lowercased = key.lowercased()
		return sensitiveKeywords.contains { lowercased.contains($0) }
	}

	static func redactedHeaderValue(key: String, value: String) -> String {
		isSensitive(key) ? redactionMark : value
	}

	/// Masks the values of sensitive query items, keeping the rest intact.
	static func redactedURLString(_ url: URL) -> String {
		guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false),
			  let queryItems = components.queryItems else {
			return url.absoluteString
		}
		components.queryItems = queryItems.map { item in
			isSensitive(item.name) ? URLQueryItem(name: item.name, value: redactionMark) : item
		}
		return components.string ?? url.absoluteString
	}

	/// Recursively masks the values of sensitive keys in a JSON body. Non-JSON
	/// bodies are returned unchanged — we can't structurally redact what we
	/// can't parse, so callers must avoid logging bodies of unknown shape.
	static func redactedBody(_ data: Data) -> String {
		guard let json = try? JSONSerialization.jsonObject(with: data, options: [.fragmentsAllowed]),
			  let output = try? JSONSerialization.data(withJSONObject: redactJSON(json)),
			  let string = String(data: output, encoding: .utf8) else {
			return String(data: data, encoding: .utf8) ?? "<non-UTF8 \(data.count) bytes>"
		}
		return string
	}

	private static func redactJSON(_ value: Any) -> Any {
		if let dictionary = value as? [String: Any] {
			var result = [String: Any]()
			for (key, nested) in dictionary {
				result[key] = isSensitive(key) ? redactionMark : redactJSON(nested)
			}
			return result
		}
		if let array = value as? [Any] {
			return array.map { redactJSON($0) }
		}
		return value
	}
}

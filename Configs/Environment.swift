//
//  Environment.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 3/7/25.
//

import Foundation

public enum Environment {
	enum Keys {
		static let apiKey = "API_KEY"
		static let apiHost = "API_HOST"
		static let baseURL = "BASE_URL"
	}

	public struct Config {
		public let apiKey: String
		public let apiHost: String
		public let baseURL: URL
	}

	public enum Error: Swift.Error, CustomStringConvertible {
		case missingKey(String)
		case emptyValue(String)
		case invalidURL(String)

		public var description: String {
			switch self {
			case .missingKey(let key):
				return "Missing required Info.plist key: \(key)"
			case .emptyValue(let key):
				return """
				\(key) is not configured.

				Copy `Configs/Secrets.Template.xcconfig` to \
				`Configs/Secrets.Debug.xcconfig` and \
				`Configs/Secrets.Release.xcconfig`, then fill in your values.

				See README → Getting Started for details.
				"""
			case .invalidURL(let value):
				return "Invalid URL: \(value)"
			}
		}
	}

	public static func load() throws -> Config {
		try load(from: Bundle.main.infoDictionary)
	}

	public static func load(from dict: [String: Any]?) throws -> Config {
		guard let dict else {
			throw Error.missingKey("Info.plist")
		}

		let apiKey = try value(for: Keys.apiKey, in: dict)
		let apiHost = try value(for: Keys.apiHost, in: dict)
		let baseURLString = try value(for: Keys.baseURL, in: dict)

		guard let baseURL = URL(string: baseURLString) else {
			throw Error.invalidURL(baseURLString)
		}

		return Config(
			apiKey: apiKey,
			apiHost: apiHost,
			baseURL: baseURL
		)
	}

	/// Treats an empty string the same as a missing key: when the secrets
	/// xcconfig files are absent, Info.plist still contains the keys but
	/// build-setting expansion resolves them to empty strings.
	private static func value(for key: String, in dict: [String: Any]) throws -> String {
		guard let value = dict[key] as? String else {
			throw Error.missingKey(key)
		}
		guard !value.isEmpty else {
			throw Error.emptyValue(key)
		}
		return value
	}
}

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
		case invalidURL(String)

		public var description: String {
			switch self {
			case .missingKey(let key):
				return "Missing required Info.plist key: \(key)"
			case .invalidURL(let value):
				return "Invalid URL: \(value)"
			}
		}
	}

	public static func load() throws -> Config {
		guard let dict = Bundle.main.infoDictionary else {
			throw Error.missingKey("Info.plist")
		}

		guard let apiKey = dict[Keys.apiKey] as? String else {
			throw Error.missingKey(Keys.apiKey)
		}

		guard let apiHost = dict[Keys.apiHost] as? String else {
			throw Error.missingKey(Keys.apiHost)
		}

		guard let baseURLString = dict[Keys.baseURL] as? String else {
			throw Error.missingKey(Keys.baseURL)
		}
		guard let baseURL = URL(string: baseURLString) else {
			throw Error.invalidURL(dict[Keys.baseURL] as? String ?? "nil")
		}

		return Config(
			apiKey: apiKey,
			apiHost: apiHost,
			baseURL: baseURL
		)
	}
}

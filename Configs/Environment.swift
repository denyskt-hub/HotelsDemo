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
				return """
				BASE_URL is not a usable URL: \(value)

				It must be absolute, with a scheme and a host, and must not \
				carry credentials — for example `https://api.example.com`.

				In `.xcconfig` files `//` starts a comment, so a plain \
				`https://api.example.com` collapses to `https:`. Write it \
				with the `$()` trick exactly as in the template:
				BASE_URL = https:/$()/api.example.com

				See README → Getting Started for details.
				"""
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

		let baseURL = try baseURL(from: baseURLString)

		return Config(
			apiKey: apiKey,
			apiHost: apiHost,
			baseURL: baseURL
		)
	}

	/// `URL(string:)` alone is far too permissive for a base URL: it happily
	/// accepts `https:` or `api.example.com`, which then compose into endpoint
	/// URLs that look fine and fail every request at runtime. `https:` is not a
	/// hypothetical — it is exactly what an `.xcconfig` yields when the `$()`
	/// trick is omitted and `//` starts a comment. Requiring a scheme and a
	/// host turns that into an explanation at launch.
	///
	/// Credentials are rejected rather than ignored: endpoints now carry the
	/// whole base URL through, and `SensitiveDataRedactor` masks query items
	/// and headers — not userinfo — so a `user:pw@host` base URL would print
	/// verbatim in the request log. This API authenticates by header anyway.
	private static func baseURL(from string: String) throws -> URL {
		guard
			let url = URL(string: string),
			let scheme = url.scheme, !scheme.isEmpty,
			let host = url.host(), !host.isEmpty,
			url.user() == nil, url.password() == nil
		else {
			throw Error.invalidURL(string)
		}
		return url
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

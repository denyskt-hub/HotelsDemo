//
//  LoggingHTTPClient.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 25/7/25.
//

import Foundation

public final class LoggingHTTPClient: HTTPClient {
	private let client: HTTPClient

	public init(client: HTTPClient) {
		self.client = client
	}

	public func perform(_ request: URLRequest) async throws -> (Data, HTTPURLResponse) {
		#if DEBUG
		let startTime = Date()
		let requestID = String(UUID().uuidString.prefix(6))
		Logger.log("🔍 [\(requestID)] Starting request...", level: .debug, tag: .networking)

		do {
			let (data, response) = try await client.perform(request)
			log(startTime, requestID, request, response)
			return (data, response)
		} catch {
			log(startTime, requestID, request, error)
			throw error
		}

		#else
		return try await client.perform(request)
		#endif
	}

	private func log(
		_ startTime: Date,
		_ requestID: String,
		_ request: URLRequest,
		_ response: HTTPURLResponse
	) {
		var logOutput = "=== [\(requestID)] HTTP Request Start ===\n"
		logOutput += curlRepresentation(of: request)

		let statusCodeLocalizedString = HTTPURLResponse.localizedString(forStatusCode: response.statusCode)
		logOutput += "\n\n✅ [\(requestID)] Response: \(response.statusCode) \(statusCodeLocalizedString)"

		let duration = Date().timeIntervalSince(startTime)
		logOutput += String(format: "\n🕑 [\(requestID)] Duration: %.2f seconds", duration)

		logOutput += "\n=== [\(requestID)] HTTP Request End ===\n"
		Logger.log(logOutput, level: .debug, tag: .networking)
	}

	private func log(
		_ startTime: Date,
		_ requestID: String,
		_ request: URLRequest,
		_ error: Error
	) {
		var logOutput = "=== [\(requestID)] HTTP Request Start ===\n"
		logOutput += curlRepresentation(of: request)

		logOutput += "\n\n❌ [\(requestID)] Error: \(error)"

		let duration = Date().timeIntervalSince(startTime)
		logOutput += String(format: "\n🕑 [\(requestID)] Duration: %.2f seconds", duration)

		logOutput += "\n=== [\(requestID)] HTTP Request End ===\n"
		Logger.log(logOutput, level: .debug, tag: .networking)
	}

	private func curlRepresentation(of request: URLRequest) -> String {
		var components: [String] = ["curl -i"]

		if let method = request.httpMethod {
			components.append("-X \(method)")
		}

		if let headers = request.allHTTPHeaderFields {
			for (key, value) in headers {
				let lowercasedKey = key.lowercased()
				let redactedValue = lowercasedKey.contains("authorization") || lowercasedKey.contains("api-key") ? "***" : value
				components.append("-H \"\(key): \(redactedValue)\"")
			}
		}

		if let body = request.httpBody,
		   let bodyString = String(data: body, encoding: .utf8) {
			let escaped = bodyString.replacingOccurrences(of: "\"", with: "\\\"")
			components.append("--data \"\(escaped)\"")
		}

		if let url = request.url {
			components.append("\"\(url.absoluteString)\"")
		}

		return components.joined(separator: " \\\n  ")
	}
}

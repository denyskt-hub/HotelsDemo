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

	public func perform(_ request: URLRequest, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
		#if DEBUG
		let startTime = Date()
		let requestID = String(UUID().uuidString.prefix(6))
		Logger.log("🔍 [\(requestID)] Starting request...", tag: .networking)

		return client.perform(request) { [weak self] result in
			guard let self else { return }

			let duration = Date().timeIntervalSince(startTime)
			self.log(requestID, request, result, duration)
			completion(result)
		}
		#else
		return client.perform(request, completion: completion)
		#endif
	}

	private func log(
		_ requestID: String,
		_ request: URLRequest,
		_ result: HTTPClient.Result,
		_ duration: TimeInterval
	) {
		var logOutput = "=== [\(requestID)] HTTP Request Start ===\n"
		logOutput += curlRepresentation(of: request)

		switch result {
		case let .success((_, response)):
			let statusCodeLocalizedString = HTTPURLResponse.localizedString(forStatusCode: response.statusCode)
			logOutput += "\n\n✅ [\(requestID)] Response: \(response.statusCode) \(statusCodeLocalizedString)"
		case let .failure(error):
			logOutput += "\n\n❌ [\(requestID)] Error: \(error)"
		}

		logOutput += String(format: "\n🕑 [\(requestID)] Duration: %.2f seconds", duration)
		logOutput += "\n=== [\(requestID)] HTTP Request End ===\n"
		Logger.log(logOutput, tag: .networking)
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

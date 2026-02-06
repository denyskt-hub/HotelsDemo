//
//  RapidAPIHTTPClient.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 3/7/25.
//

import Foundation

public final class RapidAPIHTTPClient: HTTPClient {
	private enum Headers {
		static let rapidAPIHost = "X-RapidAPI-Host"
		static let rapidAPIKey = "X-RapidAPI-Key"
	}

	private let client: HTTPClient
	private let apiHost: String
	private let apiKey: String

	public init(
		client: HTTPClient,
		apiHost: String,
		apiKey: String
	) {
		self.client = client
		self.apiHost = apiHost
		self.apiKey = apiKey
	}

	public func perform(_ request: URLRequest) async throws -> (Data, HTTPURLResponse) {
		var request = request
		request.setValue(apiHost, forHTTPHeaderField: Headers.rapidAPIHost)
		request.setValue(apiKey, forHTTPHeaderField: Headers.rapidAPIKey)

		return try await client.perform(request)
	}
}

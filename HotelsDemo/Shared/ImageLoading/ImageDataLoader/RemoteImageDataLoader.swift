//
//  RemoteImageDataLoader.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 14/7/25.
//

import Foundation

public final class RemoteImageDataLoader: ImageDataLoader {
	private let client: HTTPClient

	public static let shared: ImageDataLoader = {
		DeduplicatingImageDataLoader(
			loader: RemoteImageDataLoader(client: URLSessionHTTPClient.shared)
		)
	}()

	public init(client: HTTPClient) {
		self.client = client
	}

	@discardableResult
	public func load(url: URL) async throws -> Data {
		let request = makeRequest(url: url)
		let (data, response) = try await client.perform(request)
		return try ImageDataMapper.map(data, response)
	}

	private func makeRequest(url: URL) -> URLRequest {
		var request = URLRequest(url: url)
		request.httpMethod = "GET"
		return request
	}
}

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

	private struct TaskWrapper: ImageDataLoaderTask {
		let wrapped: Task<Void, Never>

		func cancel() {
			wrapped.cancel()
		}
	}

	@discardableResult
	public func load(url: URL, completion: @Sendable @escaping (LoadResult) -> Void) -> ImageDataLoaderTask {
		let request = makeRequest(url: url)

		let task = Task {
			do {
				let (data, response) = try await client.perform(request)
				let result = try ImageDataMapper.map(data, response)
				completion(.success(result))
			} catch {
				completion(.failure(error))
			}
		}

		return TaskWrapper(wrapped: task)
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

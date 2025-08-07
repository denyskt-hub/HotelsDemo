//
//  RemoteImageDataLoader.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 14/7/25.
//

import Foundation

public final class RemoteImageDataLoader: ImageDataLoader {
	private let client: HTTPClient
	private let dispatcher: Dispatcher

	public static let shared = RemoteImageDataLoader(
		client: URLSessionHTTPClient.shared,
		dispatcher: MainQueueDispatcher()
	)

	public init(
		client: HTTPClient,
		dispatcher: Dispatcher
	) {
		self.client = client
		self.dispatcher = dispatcher
	}

	private struct HTTPClientTaskWrapper: ImageDataLoaderTask {
		let wrapped: HTTPClientTask

		func cancel() {
			wrapped.cancel()
		}
	}

	@discardableResult
	public func load(url: URL, completion: @escaping (LoadResult) -> Void) -> ImageDataLoaderTask {
		let request = makeRequest(url: url)

		let task = client.perform(request) { [weak self] result in
			guard let self else { return }

			let loadResult = LoadResult {
				switch result {
				case let .success((data, response)):
					return try ImageDataMapper.map(data, response)
				case let .failure(error):
					throw error
				}
			}

			self.dispatcher.dispatch {
				completion(loadResult)
			}
		}

		return HTTPClientTaskWrapper(wrapped: task)
	}

	private func makeRequest(url: URL) -> URLRequest {
		var request = URLRequest(url: url)
		request.httpMethod = "GET"
		return request
	}
}

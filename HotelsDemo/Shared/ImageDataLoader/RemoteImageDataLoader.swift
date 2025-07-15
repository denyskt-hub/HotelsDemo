//
//  RemoteImageDataLoader.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 14/7/25.
//

import Foundation

public final class RemoteImageDataLoader: ImageDataLoader {
	private let client: HTTPClient

	public init(client: HTTPClient) {
		self.client = client
	}

	private struct HTTPClientTaskWrapper: ImageDataLoaderTask {
		let wrapped: HTTPClientTask

		func cancel() {
			wrapped.cancel()
		}
	}

	public func load(url: URL, completion: @escaping (ImageDataLoader.Result) -> Void) -> ImageDataLoaderTask {
		let request = makeRequest(url: url)

		let task = client.perform(request) { result in
			switch result {
			case let .success((data, response)):
				do {
					let data = try ImageDataMapper.map(data, response)
					completion(.success(data))
				} catch {
					completion(.failure(error))
				}
			case let .failure(error):
				completion(.failure(error))
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

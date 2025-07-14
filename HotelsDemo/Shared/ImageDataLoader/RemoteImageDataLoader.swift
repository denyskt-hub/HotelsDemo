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
		let task = client.perform(URLRequest(url: url)) { result in
			switch result {
			case let .success((data, response)):
				if response.isOK {
					completion(.success(data))
				}
				else {
					completion(.failure(HTTPError.unexpectedStatusCode(response.statusCode)))
				}
			case let .failure(error):
				completion(.failure(error))
			}
		}
		return HTTPClientTaskWrapper(wrapped: task)
	}
}

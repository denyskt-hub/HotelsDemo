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

	public func load(url: URL, completion: @escaping (ImageDataLoader.Result) -> Void) -> ImageDataLoaderTask {
		let request = makeRequest(url: url)

		let task = client.perform(request) { [weak self] result in
			guard let self else { return }

			switch result {
			case let .success((data, response)):
				do {
					let data = try ImageDataMapper.map(data, response)
					self.dispatcher.dispatch {
						completion(.success(data))
					}
				} catch {
					self.dispatcher.dispatch {
						completion(.failure(error))
					}
				}
			case let .failure(error):
				self.dispatcher.dispatch {
					completion(.failure(error))
				}
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

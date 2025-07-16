//
//  DestinationSearchWorker.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 24/6/25.
//

import Foundation

public final class DestinationSearchWorker: DestinationSearchService {
	private let factory: DestinationRequestFactory
	private let client: HTTPClient
	private let dispatcher: Dispatcher

	public init(
		factory: DestinationRequestFactory,
		client: HTTPClient,
		dispatcher: Dispatcher
	) {
		self.factory = factory
		self.client = client
		self.dispatcher = dispatcher
	}

	public func search(query: String, completion: @escaping (DestinationSearchService.Result) -> Void) {
		precondition(!query.trimmingCharacters(in: .whitespaces).isEmpty, "Query must not be empty")

		let request = factory.makeSearchRequest(query: query)

		client.perform(request) { [weak self] result in
			guard let self else { return }

			let searchResult = DestinationSearchService.Result {
				switch result {
				case let .success((data, response)):
					return try DestinationsResponseMapper.map(data, response)
				case let .failure(error):
					throw error
				}
			}

			self.dispatcher.dispatch {
				completion(searchResult)
			}
		}
	}
}

public protocol DestinationRequestFactory {
	func makeSearchRequest(query: String) -> URLRequest
}

public final class DefaultDestinationRequestFactory: DestinationRequestFactory {
	private let url: URL

	public init(url: URL) {
		self.url = url
	}

	public func makeSearchRequest(query: String) -> URLRequest {
		let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .strictQueryValueAllowed) ?? ""
		let urlString = url.absoluteString.appending("?query=\(encodedQuery)")
		let finalURL = URL(string: urlString)!

		var request = URLRequest(url: finalURL)
		request.httpMethod = "GET"
		return request
	}
}

//
//  DestinationSearchWorker.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 24/6/25.
//

import Foundation

public final class DestinationSearchWorker: DestinationSearchService {
	private let factory: DestinationsRequestFactory
	private let client: HTTPClient
	private let dispatcher: Dispatcher

	public init(
		factory: DestinationsRequestFactory,
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

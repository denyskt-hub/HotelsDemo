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

	public init(
		factory: DestinationsRequestFactory,
		client: HTTPClient
	) {
		self.factory = factory
		self.client = client
	}

	public func search(query: String, completion: @escaping (DestinationSearchService.Result) -> Void) {
		let request = factory.makeSearchRequest(query: query)

		client.perform(request) { result in
			let searchResult = DestinationSearchService.Result {
				switch result {
				case let .success((data, response)):
					return try DestinationsResponseMapper.map(data, response)
				case let .failure(error):
					throw error
				}
			}

			completion(searchResult)
		}
	}
}

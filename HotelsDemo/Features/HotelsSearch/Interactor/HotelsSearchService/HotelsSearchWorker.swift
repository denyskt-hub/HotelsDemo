//
//  HotelsSearchWorker.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 12/7/25.
//

import Foundation

public final class HotelsSearchWorker: HotelsSearchService {
	private let factory: HotelsRequestFactory
	private let client: HTTPClient
	private let dispatcher: Dispatcher

	public init(
		factory: HotelsRequestFactory,
		client: HTTPClient,
		dispatcher: Dispatcher
	) {
		self.factory = factory
		self.client = client
		self.dispatcher = dispatcher
	}

	public func search(criteria: HotelsSearchCriteria, completion: @escaping (HotelsSearchService.Result) -> Void) {
		let request = factory.makeSearchRequest(criteria: criteria)

		client.perform(request) { [weak self] result in
			guard let self else { return }

			let searchResult = HotelsSearchService.Result {
				switch result {
				case let .success((data, response)):
					return try HotelsSearchResponseMapper.map(data, response)
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

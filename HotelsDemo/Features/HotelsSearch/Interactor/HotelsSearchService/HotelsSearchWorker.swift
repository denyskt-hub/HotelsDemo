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

	public init(
		factory: HotelsRequestFactory,
		client: HTTPClient
	) {
		self.factory = factory
		self.client = client
	}

	@discardableResult
	public func search(
		criteria: HotelsSearchCriteria,
		completion: @escaping (HotelsSearchService.Result) -> Void
	) -> HTTPClientTask {
		let request = factory.makeSearchRequest(criteria: criteria)

		return client.perform(request) { result in
			let searchResult = HotelsSearchService.Result {
				switch result {
				case let .success((data, response)):
					return try HotelsSearchResponseMapper.map(data, response)
				case let .failure(error):
					throw error
				}
			}

			completion(searchResult)
		}
	}
}

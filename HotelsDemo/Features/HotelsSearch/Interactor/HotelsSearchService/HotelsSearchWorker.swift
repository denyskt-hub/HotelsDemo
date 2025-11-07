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

	public func search(criteria: HotelsSearchCriteria) async throws -> [Hotel] {
		let request = factory.makeSearchRequest(criteria: criteria)

		let (data, response) = try await client.perform(request)

		return try HotelsSearchResponseMapper.map(data, response)
	}
}

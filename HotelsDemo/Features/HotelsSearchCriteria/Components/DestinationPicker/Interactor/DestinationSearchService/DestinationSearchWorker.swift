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

	public func search(query: String) async throws -> [Destination] {
		let request = factory.makeSearchRequest(query: query)

		let (data, response) = try await client.perform(request)

		return try DestinationsResponseMapper.map(data, response)
	}
}

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

	private struct TaskWrapper: HTTPClientTask {
		let wrapped: Task<Void, Never>

		func cancel() {
			wrapped.cancel()
		}
	}

	@discardableResult
	public func search(
		criteria: HotelsSearchCriteria,
		completion: @Sendable @escaping (HotelsSearchService.Result) -> Void
	) -> HTTPClientTask {
		let request = factory.makeSearchRequest(criteria: criteria)

		let task = Task {
			do {
				let (data, response) = try await client.perform(request)
				let result = try HotelsSearchResponseMapper.map(data, response)
				completion(.success(result))
			} catch {
				completion(.failure(error))
			}
		}

		return TaskWrapper(wrapped: task)
	}

	public func search(criteria: HotelsSearchCriteria) async throws -> [Hotel] {
		let request = factory.makeSearchRequest(criteria: criteria)

		let (data, response) = try await client.perform(request)

		return try HotelsSearchResponseMapper.map(data, response)
	}
}

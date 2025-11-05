//
//  DestinationSearchService.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 24/6/25.
//

import Foundation

public protocol DestinationSearchService: Sendable {
	typealias Result = Swift.Result<[Destination], Error>

	/// The completion handler can be invoked in any thread.
	/// Clients are responsible to dispatch to appropriate threads, if needed.
	@available(*, deprecated, message: "Use async version")
	func search(query: String, completion: @escaping (Result) -> Void)

	func search(query: String) async throws -> [Destination]
}

extension DestinationSearchService {
	public func search(query: String) async throws -> [Destination] {
		try await withCheckedThrowingContinuation { continuation in
			search(query: query) { result in
				switch result {
				case let .success(destinations):
					continuation.resume(returning: destinations)
				case let .failure(error):
					continuation.resume(throwing: error)
				}
			}
		}
	}
}

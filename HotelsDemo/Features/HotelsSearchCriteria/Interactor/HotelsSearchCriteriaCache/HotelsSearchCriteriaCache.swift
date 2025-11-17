//
//  HotelsSearchCriteriaCache.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 24/6/25.
//

import Foundation

public protocol HotelsSearchCriteriaCache: Sendable {
	typealias SaveResult = Result<Void, Error>

	@available(*, deprecated, message: "Use async function instead")
	func save(_ criteria: HotelsSearchCriteria, completion: @Sendable @escaping (SaveResult) -> Void)

	func save(_ criteria: HotelsSearchCriteria) async throws
}

extension HotelsSearchCriteriaCache {
	public func save(_ criteria: HotelsSearchCriteria) async throws {
		try await withCheckedThrowingContinuation { continuation in
			save(criteria) { result in
				switch result {
				case .success:
					continuation.resume(returning: ())
				case let .failure(error):
					continuation.resume(throwing: error)
				}
			}
		}
	}
}

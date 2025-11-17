//
//  SearchCriteriaProvider.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 24/6/25.
//

import Foundation

public protocol HotelsSearchCriteriaProvider: Sendable {
	typealias RetrieveResult = Result<HotelsSearchCriteria, Error>

	@available(*, deprecated, message: "Use async function")
	func retrieve(completion: @Sendable @escaping (RetrieveResult) -> Void)

	func retrieve() async throws -> HotelsSearchCriteria
}

extension HotelsSearchCriteriaProvider {
	func fallback(to secondary: HotelsSearchCriteriaProvider) -> HotelsSearchCriteriaProvider {
		FallbackHotelsSearchCriteriaProvider(primary: self, secondary: secondary)
	}
}

public enum SearchCriteriaError: Error, Equatable {
	case notFound
}

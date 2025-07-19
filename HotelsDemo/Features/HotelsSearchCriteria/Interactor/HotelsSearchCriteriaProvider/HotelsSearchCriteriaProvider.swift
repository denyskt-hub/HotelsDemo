//
//  SearchCriteriaProvider.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 24/6/25.
//

import Foundation

public protocol HotelsSearchCriteriaProvider {
	typealias RetrieveResult = Result<HotelsSearchCriteria, Error>

	func retrieve(completion: @escaping (RetrieveResult) -> Void)
}

extension HotelsSearchCriteriaProvider {
	func fallback(to secondary: HotelsSearchCriteriaProvider) -> HotelsSearchCriteriaProvider {
		FallbackHotelsSearchCriteriaProvider(primary: self, secondary: secondary)
	}
}

public enum SearchCriteriaError: Error, Equatable {
	case notFound
}

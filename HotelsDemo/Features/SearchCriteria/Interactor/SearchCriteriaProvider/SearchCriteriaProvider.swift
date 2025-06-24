//
//  SearchCriteriaProvider.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 24/6/25.
//

import Foundation

public protocol SearchCriteriaProvider {
	typealias RetrieveResult = Result<SearchCriteria, Error>

	func retrieve(completion: @escaping (RetrieveResult) -> Void)
}

extension SearchCriteriaProvider {
	func fallback(to secondary: SearchCriteriaProvider) -> FallbackSearchCriteriaProvider {
		FallbackSearchCriteriaProvider(primary: self, secondary: secondary)
	}
}

enum SearchCriteriaError: Swift.Error {
	case notFound
}

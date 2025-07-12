//
//  SearchCriteriaStore.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 19/6/25.
//

import Foundation

public protocol SearchCriteriaStore: SearchCriteriaProvider, SearchCriteriaCache {
	func save(_ criteria: SearchCriteria, completion: @escaping (SaveResult) -> Void)
	func retrieve(completion: @escaping (RetrieveResult) -> Void)
}

extension SearchCriteriaStore {
	public func saveIgnoringResult(_ criteria: SearchCriteria) {
		save(criteria) { _ in }
	}
}

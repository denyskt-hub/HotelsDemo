//
//  SearchCriteriaStore.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 19/6/25.
//

import Foundation

protocol SearchCriteriaStore {
	func save(_ criteria: SearchCriteria, completion: @escaping (Error?) -> Void)
	func retrieve(completion: @escaping (Result<SearchCriteria?, Error>) -> Void)
}

final class InMemorySearchCriteriaStore: SearchCriteriaStore {
	private var criteria: SearchCriteria?
	
	func save(_ criteria: SearchCriteria, completion: @escaping (Error?) -> Void) {
		self.criteria = criteria
		completion(nil)
	}
	
	func retrieve(completion: @escaping (Result<SearchCriteria?, Error>) -> Void) {
		completion(.success(criteria))
	}
}

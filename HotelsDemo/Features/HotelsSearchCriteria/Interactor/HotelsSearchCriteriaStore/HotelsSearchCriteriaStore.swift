//
//  HotelsSearchCriteriaStore.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 19/6/25.
//

import Foundation

public protocol HotelsSearchCriteriaStore: HotelsSearchCriteriaProvider, HotelsSearchCriteriaCache {
	func save(_ criteria: HotelsSearchCriteria, completion: @escaping (SaveResult) -> Void)
	func retrieve(completion: @escaping (RetrieveResult) -> Void)
}

extension HotelsSearchCriteriaStore {
	public func saveIgnoringResult(_ criteria: HotelsSearchCriteria) {
		save(criteria) { _ in }
	}
}

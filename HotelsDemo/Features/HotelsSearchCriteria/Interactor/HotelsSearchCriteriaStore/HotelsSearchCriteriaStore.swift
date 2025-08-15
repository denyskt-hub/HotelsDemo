//
//  HotelsSearchCriteriaStore.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 19/6/25.
//

import Foundation

public protocol HotelsSearchCriteriaStore: HotelsSearchCriteriaProvider, HotelsSearchCriteriaCache {
}

extension HotelsSearchCriteriaStore {
	public func saveIgnoringResult(_ criteria: HotelsSearchCriteria) {
		save(criteria) { _ in }
	}
}

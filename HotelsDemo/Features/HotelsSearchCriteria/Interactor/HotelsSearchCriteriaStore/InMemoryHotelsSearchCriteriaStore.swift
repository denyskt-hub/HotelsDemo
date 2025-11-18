//
//  InMemoryHotelsSearchCriteriaStore.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 20/6/25.
//

import Foundation

public actor InMemoryHotelsSearchCriteriaStore: HotelsSearchCriteriaStore {
	private var criteria: HotelsSearchCriteria?

	public init(criteria: HotelsSearchCriteria? = nil) {
		self.criteria = criteria
	}

	public func save(_ criteria: HotelsSearchCriteria) async throws {
		self.criteria = criteria
	}

	public func retrieve() async throws -> HotelsSearchCriteria {
		guard let criteria = criteria else {
			throw SearchCriteriaError.notFound
		}
		return criteria
	}
}

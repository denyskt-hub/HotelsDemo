//
//  DispatchingDecorator+HotelsSearchCriteriaStore.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 3/10/25.
//

import Foundation

extension DispatchingDecorator: HotelsSearchCriteriaStore where T: HotelsSearchCriteriaStore {}

public extension HotelsSearchCriteriaStore {
	func dispatch(to dispatcher: Dispatcher) -> HotelsSearchCriteriaStore {
		DispatchingDecorator(decoratee: self, dispatcher: dispatcher)
	}
}

// MARK: - HotelsSearchCriteriaCache

extension DispatchingDecorator: HotelsSearchCriteriaCache where T: HotelsSearchCriteriaCache {
	public func save(_ criteria: HotelsSearchCriteria) async throws {
		try await decoratee.save(criteria)
	}
}

// MARK: - HotelsSearchCriteriaProvider

extension DispatchingDecorator: HotelsSearchCriteriaProvider where T: HotelsSearchCriteriaProvider {
	public func retrieve() async throws -> HotelsSearchCriteria {
		try await decoratee.retrieve()
	}
}

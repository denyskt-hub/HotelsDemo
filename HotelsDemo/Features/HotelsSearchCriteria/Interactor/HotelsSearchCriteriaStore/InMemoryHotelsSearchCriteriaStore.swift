//
//  InMemoryHotelsSearchCriteriaStore.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 20/6/25.
//

import Foundation
import Synchronization

public final class InMemoryHotelsSearchCriteriaStore: HotelsSearchCriteriaStore {
	private let criteria: Mutex<HotelsSearchCriteria?>

	public init(criteria: HotelsSearchCriteria? = nil) {
		self.criteria = Mutex(criteria)
	}

	public func save(_ criteria: HotelsSearchCriteria, completion: @escaping (SaveResult) -> Void) {
		self.criteria.withLock { $0 = criteria }
		completion(.success(()))
	}

	public func retrieve(completion: @escaping (RetrieveResult) -> Void) {
		guard let criteria = self.criteria.withLock({ $0 }) else {
			return completion(.failure(SearchCriteriaError.notFound))
		}
		completion(.success(criteria))
	}
}

//
//  InMemoryHotelsSearchCriteriaStore.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 20/6/25.
//

import Foundation

public final class InMemoryHotelsSearchCriteriaStore: HotelsSearchCriteriaStore {
	private let queue = DispatchQueue(label: "\(InMemoryHotelsSearchCriteriaStore.self)Queue")

	private var criteria: HotelsSearchCriteria?

	public init() {
		// Required for initialization in tests
	}

	public func save(_ criteria: HotelsSearchCriteria, completion: @escaping (SaveResult) -> Void) {
		queue.async {
			self.criteria = criteria
			completion(.success(()))
		}
	}

	public func retrieve(completion: @escaping (RetrieveResult) -> Void) {
		queue.async {
			guard let criteria = self.criteria else {
				return completion(.failure(SearchCriteriaError.notFound))
			}
			completion(.success(criteria))
		}
	}
}

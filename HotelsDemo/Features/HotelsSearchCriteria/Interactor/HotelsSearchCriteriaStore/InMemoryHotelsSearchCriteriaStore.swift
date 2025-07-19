//
//  InMemoryHotelsSearchCriteriaStore.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 20/6/25.
//

import Foundation

public final class InMemoryHotelsSearchCriteriaStore: HotelsSearchCriteriaStore {
	private let queue = DispatchQueue(label: "\(InMemoryHotelsSearchCriteriaStore.self)Queue")

	private let dispatcher: Dispatcher

	private var criteria: HotelsSearchCriteria?

	public init(dispatcher: Dispatcher) {
		self.dispatcher = dispatcher
	}

	public func save(_ criteria: HotelsSearchCriteria, completion: @escaping (SaveResult) -> Void) {
		queue.async {
			self.criteria = criteria
			self.dispatcher.dispatch {
				completion(.none)
			}
		}
	}

	public func retrieve(completion: @escaping (RetrieveResult) -> Void) {
		queue.async {
			self.dispatcher.dispatch {
				guard let criteria = self.criteria else {
					return completion(.failure(SearchCriteriaError.notFound))
				}
				completion(.success(criteria))
			}
		}
	}
}

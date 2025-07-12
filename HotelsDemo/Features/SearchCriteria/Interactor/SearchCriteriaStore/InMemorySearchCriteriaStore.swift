//
//  InMemorySearchCriteriaStore.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 20/6/25.
//

import Foundation

public final class InMemorySearchCriteriaStore: SearchCriteriaStore {
	private let queue = DispatchQueue(label: "\(InMemorySearchCriteriaStore.self)Queue")

	private let dispatcher: Dispatcher

	private var criteria: SearchCriteria?

	public init(dispatcher: Dispatcher) {
		self.dispatcher = dispatcher
	}

	public func save(_ criteria: SearchCriteria, completion: @escaping (SaveResult) -> Void) {
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

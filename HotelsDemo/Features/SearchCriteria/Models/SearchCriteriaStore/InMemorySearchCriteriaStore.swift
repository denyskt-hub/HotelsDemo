//
//  InMemorySearchCriteriaStore.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 20/6/25.
//

import Foundation

final class InMemorySearchCriteriaStore: SearchCriteriaStore {
	private let queue = DispatchQueue(label: "\(InMemorySearchCriteriaStore.self)Queue")

	private let dispatcher: Dispatcher

	private var criteria: SearchCriteria = .default

	init(dispatcher: Dispatcher) {
		self.dispatcher = dispatcher
	}

	func save(_ criteria: SearchCriteria, completion: @escaping (SaveResult) -> Void) {
		queue.async {
			self.criteria = criteria
			self.dispatcher.dispatch {
				completion(.none)
			}
		}
	}
	
	func retrieve(completion: @escaping (RetrieveResult) -> Void) {
		queue.async {
			self.dispatcher.dispatch {
				completion(.success(self.criteria))
			}
		}
	}
}

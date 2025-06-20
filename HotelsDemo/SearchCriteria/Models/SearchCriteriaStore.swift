//
//  SearchCriteriaStore.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 19/6/25.
//

import Foundation

protocol SearchCriteriaStore {
	func save(_ criteria: SearchCriteria, completion: @escaping (Error?) -> Void)
	func retrieve(completion: @escaping (Result<SearchCriteria, Error>) -> Void)
}

extension SearchCriteriaStore {
	func update(
		_ transform: @escaping (inout SearchCriteria) -> Void,
		completion: @escaping ((Result<SearchCriteria, Error>) -> Void)
	) {
		retrieve { result in
			switch result {
			case .success(var criteria):
				transform(&criteria)

				self.save(criteria) { error in
					if let error = error {
						completion(.failure(error))
					} else {
						completion(.success(criteria))
					}
				}
			case let .failure(error):
				completion(.failure(error))
			}
		}
	}
}

final class InMemorySearchCriteriaStore: SearchCriteriaStore {
	private let queue = DispatchQueue(label: "\(InMemorySearchCriteriaStore.self)Queue")

	private let dispatcher: Dispatcher

	private var criteria: SearchCriteria = .default

	init(dispatcher: Dispatcher) {
		self.dispatcher = dispatcher
	}

	func save(_ criteria: SearchCriteria, completion: @escaping (Error?) -> Void) {
		queue.async {
			self.criteria = criteria
			self.dispatcher.dispatch {
				completion(nil)
			}
		}
	}
	
	func retrieve(completion: @escaping (Result<SearchCriteria, Error>) -> Void) {
		queue.async {
			self.dispatcher.dispatch {
				completion(.success(self.criteria))
			}
		}
	}
}

final class CodableSearchCriteriaStore: SearchCriteriaStore {
	private let queue = DispatchQueue(label: "\(CodableSearchCriteriaStore.self)Queue")

	private let storeURL: URL
	private let dispatcher: Dispatcher

	init(storeURL: URL, dispatcher: Dispatcher) {
		self.storeURL = storeURL
		self.dispatcher = dispatcher
	}

	func save(_ criteria: SearchCriteria, completion: @escaping (Error?) -> Void) {
		_save(criteria) { error in
			self.dispatcher.dispatch {
				completion(error)
			}
		}
	}

	private func _save(_ criteria: SearchCriteria, completion: @escaping (Error?) -> Void) {
		queue.async {
			do {
				let data = try JSONEncoder().encode(criteria)
				try data.write(to: self.storeURL)
				completion(nil)
			} catch {
				completion(error)
			}
		}
	}

	func retrieve(completion: @escaping (Result<SearchCriteria, Error>) -> Void) {
		_retrieve { result in
			self.dispatcher.dispatch {
				completion(result)
			}
		}
	}

	func _retrieve(completion: @escaping (Result<SearchCriteria, Error>) -> Void) {
		queue.async {
			guard FileManager.default.fileExists(atPath: self.storeURL.path) else {
				return completion(.success(.default))
			}

			do {
				let data = try Data(contentsOf: self.storeURL)
				let criteria = try JSONDecoder().decode(SearchCriteria.self, from: data)
				completion(.success(criteria))
			} catch {
				completion(.failure(error))
			}
		}
	}
}

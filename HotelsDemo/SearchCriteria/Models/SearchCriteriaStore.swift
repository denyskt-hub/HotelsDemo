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
	private var criteria: SearchCriteria = .default

	func save(_ criteria: SearchCriteria, completion: @escaping (Error?) -> Void) {
		self.criteria = criteria
		completion(nil)
	}
	
	func retrieve(completion: @escaping (Result<SearchCriteria, Error>) -> Void) {
		completion(.success(criteria))
	}
}

final class CodableSearchCriteriaStore: SearchCriteriaStore {
	private let queue = DispatchQueue(label: "CodableSearchCriteriaStore.queue")

	private var storeURL: URL {
		let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
		return documentsURL.appendingPathComponent("CodableSearchCriteriaStore.store")
	}

	private let dispatcher: Dispatcher

	init(dispatcher: Dispatcher) {
		self.dispatcher = dispatcher
	}

	func save(_ criteria: SearchCriteria, completion: @escaping (Error?) -> Void) {
		_save(criteria) { [dispatcher] error in
			dispatcher.dispatch {
				completion(error)
			}
		}
	}

	private func _save(_ criteria: SearchCriteria, completion: @escaping (Error?) -> Void) {
		queue.async { [storeURL] in
			do {
				let data = try JSONEncoder().encode(criteria)
				try data.write(to: storeURL)
				completion(nil)
			} catch {
				completion(error)
			}
		}
	}

	func retrieve(completion: @escaping (Result<SearchCriteria, Error>) -> Void) {
		_retrieve { [dispatcher] result in
			dispatcher.dispatch {
				completion(result)
			}
		}
	}

	func _retrieve(completion: @escaping (Result<SearchCriteria, Error>) -> Void) {
		queue.async { [storeURL] in
			guard FileManager.default.fileExists(atPath: storeURL.path) else {
				return completion(.success(.default))
			}

			do {
				let data = try Data(contentsOf: storeURL)
				let criteria = try JSONDecoder().decode(SearchCriteria.self, from: data)
				completion(.success(criteria))
			} catch {
				completion(.failure(error))
			}
		}
	}
}

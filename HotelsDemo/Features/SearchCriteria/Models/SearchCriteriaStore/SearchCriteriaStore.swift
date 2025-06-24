//
//  SearchCriteriaStore.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 19/6/25.
//

import Foundation

protocol SearchCriteriaStore {
	typealias SaveResult = Error?
	typealias RetrieveResult = Result<SearchCriteria, Error>

	func save(_ criteria: SearchCriteria, completion: @escaping (SaveResult) -> Void)
	func retrieve(completion: @escaping (RetrieveResult) -> Void)
}

extension SearchCriteriaStore {
	func update(
		_ transform: @escaping (inout SearchCriteria) -> Void,
		completion: @escaping ((RetrieveResult) -> Void)
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

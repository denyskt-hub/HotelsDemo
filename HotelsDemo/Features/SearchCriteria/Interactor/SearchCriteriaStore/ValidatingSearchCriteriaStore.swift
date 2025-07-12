//
//  ValidatingSearchCriteriaStore.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 24/6/25.
//

import Foundation

public final class ValidatingSearchCriteriaStore: SearchCriteriaStore {
	private let decoratee: SearchCriteriaStore
	private let validator: SearchCriteriaValidator

	public init(
		decoratee: SearchCriteriaStore,
		validator: SearchCriteriaValidator
	) {
		self.decoratee = decoratee
		self.validator = validator
	}

	public func save(_ criteria: SearchCriteria, completion: @escaping (SaveResult) -> Void) {
		let validated = validator.validate(criteria)
		decoratee.save(validated, completion: completion)
	}
	
	public func retrieve(completion: @escaping (RetrieveResult) -> Void) {
		decoratee.retrieve() { [weak self] result in
			guard let self else { return }

			switch result {
			case let .success(criteria):
				let validated = self.validator.validate(criteria)
				if validated != criteria {
					self.decoratee.saveIgnoringResult(validated)
				}
				completion(.success(validated))
			case let .failure(error):
				completion(.failure(error))
			}
		}
	}
}

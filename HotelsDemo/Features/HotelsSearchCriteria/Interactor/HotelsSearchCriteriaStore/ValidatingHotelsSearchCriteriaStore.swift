//
//  ValidatingHotelsSearchCriteriaStore.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 24/6/25.
//

import Foundation

public final class ValidatingHotelsSearchCriteriaStore: HotelsSearchCriteriaStore {
	private let decoratee: HotelsSearchCriteriaStore
	private let validator: HotelsSearchCriteriaValidator

	public init(
		decoratee: HotelsSearchCriteriaStore,
		validator: HotelsSearchCriteriaValidator
	) {
		self.decoratee = decoratee
		self.validator = validator
	}

	public func save(_ criteria: HotelsSearchCriteria, completion: @escaping (SaveResult) -> Void) {
		let validated = validator.validate(criteria)
		decoratee.save(validated, completion: completion)
	}

	public func retrieve(completion: @escaping (RetrieveResult) -> Void) {
		decoratee.retrieve { [weak self] result in
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

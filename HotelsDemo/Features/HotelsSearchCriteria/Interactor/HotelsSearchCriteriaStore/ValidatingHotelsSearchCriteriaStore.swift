//
//  ValidatingHotelsSearchCriteriaStore.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 24/6/25.
//

import Foundation

///
/// A `HotelsSearchCriteriaStore` decorator that validates criteria on both save and read.
///
/// Validation happens twice to ensure the store always returns valid search criteria:
/// - **Multiple sources of criteria:** Data may be set by different parts of the app. Validation before
///   saving ensures only valid data is persisted.
/// - **Time-sensitive fields:** Check-in/out dates may expire between app launches. Validation on read
///   corrects outdated data before use.
/// - **Auto-persistence after read validation:** If read validation changes the data, the corrected
///   version is saved back immediately, keeping storage consistent.
///
/// This design guarantees consistent, valid search criteria regardless of when or how it is set.
///
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

	public func save(_ criteria: HotelsSearchCriteria, completion: @Sendable @escaping (SaveResult) -> Void) {
		let validated = validator.validate(criteria)

		if validated != criteria {
			Logger.log("Criteria validated: \(criteria) -> \(validated)", level: .debug)
		}

		decoratee.save(validated, completion: completion)
	}

	public func retrieve(completion: @Sendable @escaping (RetrieveResult) -> Void) {
		decoratee.retrieve { [weak self] result in
			guard let self else { return }

			switch result {
			case let .success(criteria):
				let validated = self.validator.validate(criteria)

				if validated != criteria {
					Logger.log("Retrieved criteria validated: \(criteria) -> \(validated)", level: .debug)

					self.decoratee.save(validated) { saveResult in
						if case .failure(let error) = saveResult {
							Logger.log("Failed to save validated criteria: \(error)", level: .error)
						}
					}
				}

				completion(.success(validated))
			case let .failure(error):
				Logger.log("Retrieve failed: \(error)", level: .error)
				completion(.failure(error))
			}
		}
	}
}

//
//  FallbackHotelsSearchCriteriaProvider.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 24/6/25.
//

import Foundation

public final class FallbackHotelsSearchCriteriaProvider: HotelsSearchCriteriaProvider {
	private let primary: HotelsSearchCriteriaProvider
	private let secondary: HotelsSearchCriteriaProvider

	init(
		primary: HotelsSearchCriteriaProvider,
		secondary: HotelsSearchCriteriaProvider
	) {
		self.primary = primary
		self.secondary = secondary
	}

	public func retrieve(completion: @escaping (HotelsSearchCriteriaProvider.RetrieveResult) -> Void) {
		primary.retrieve { [weak self] result in
			guard let self else { return }

			switch result {
			case .success(let criteria):
				completion(.success(criteria))
			case .failure:
				self.secondary.retrieve(completion: completion)
			}
		}
	}
}

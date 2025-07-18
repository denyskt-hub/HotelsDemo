//
//  FallbackSearchCriteriaProvider.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 24/6/25.
//

import Foundation

public final class FallbackSearchCriteriaProvider: SearchCriteriaProvider {
	private let primary: SearchCriteriaProvider
	private let secondary: SearchCriteriaProvider

	init(
		primary: SearchCriteriaProvider,
		secondary: SearchCriteriaProvider
	) {
		self.primary = primary
		self.secondary = secondary
	}

	public func retrieve(completion: @escaping (SearchCriteriaProvider.RetrieveResult) -> Void) {
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

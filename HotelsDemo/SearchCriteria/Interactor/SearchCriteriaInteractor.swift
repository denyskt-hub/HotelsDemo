//
//  SearchCriteriaInteractor.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 19/6/25.
//

import Foundation

protocol SearchCriteriaBusinessLogic {
	func loadCriteria(request: SearchCriteriaModels.Load.Request)
	func updateDestination(request: SearchCriteriaModels.UpdateDestination.Request)
}

final class SearchCriteriaInteractor: SearchCriteriaBusinessLogic {
	private let store: SearchCriteriaStore

	var presenter: SearchCriteriaPresentationLogic?

	init(store: SearchCriteriaStore) {
		self.store = store
	}

	func loadCriteria(request: SearchCriteriaModels.Load.Request) {
		load { [weak self] result in
			guard let self else { return }

			switch result {
			case .success(let criteria):
				self.presentLoadedCriteria(criteria ?? .default)
			case .failure:
				self.presentLoadedCriteria(.default)
			}
		}
	}

	struct UpdateError: Error {}

	func updateDestination(request: SearchCriteriaModels.UpdateDestination.Request) {
		load { [weak self] result in
			guard let self else { return }

			switch result {
			case .success(let criteria):
				var criteria = criteria ?? .default
				criteria.destination = request.destination

				self.save(criteria) { error in
					if let error = error {
						self.presentError(error)
					}
					else {
						self.presentUpdatedCriteria(criteria)
					}
				}

			case .failure:
				self.presentError(UpdateError())
			}
		}
	}

	private func load(_ completion: @escaping (Result<SearchCriteria?, Error>) -> Void) {
		store.retrieve(completion: completion)
	}

	private func save(_ criteria: SearchCriteria, _ completion: @escaping (Error?) -> Void) {
		store.save(criteria, completion: completion)
	}

	private func presentLoadedCriteria(_ criteria: SearchCriteria) {
		presenter?.presentCriteria(response: SearchCriteriaModels.Load.Response(criteria: criteria))
	}

	private func presentUpdatedCriteria(_ criteria: SearchCriteria) {
		presenter?.presentCriteria(response: SearchCriteriaModels.UpdateDestination.Response(criteria: criteria))
	}

	private func presentError(_ error: Error) {
		print(error)
	}
}

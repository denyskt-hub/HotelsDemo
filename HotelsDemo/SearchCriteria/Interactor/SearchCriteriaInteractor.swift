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
			case let .success(criteria):
				self.presentLoadedCriteria(criteria)
			case let .failure(error):
				self.presentLoadError(error)
			}
		}
	}

	func updateDestination(request: SearchCriteriaModels.UpdateDestination.Request) {
		update(request.destination) { [weak self] result in
			guard let self else { return }

			switch result {
			case let .success(criteria):
				self.presentUpdatedCriteria(criteria)
			case let .failure(error):
				self.presentUpdateError(error)
			}
		}
	}

	private func load(_ completion: @escaping (Result<SearchCriteria, Error>) -> Void) {
		store.retrieve(completion: completion)
	}

	private func update(_ destination: Destination, completion: @escaping (Result<SearchCriteria, Error>) -> Void) {
		store.update({ $0.destination = destination }, completion: completion)
	}

	private func save(_ criteria: SearchCriteria, _ completion: @escaping (Error?) -> Void) {
		store.save(criteria, completion: completion)
	}

	private func presentLoadedCriteria(_ criteria: SearchCriteria) {
		presenter?.presentCriteria(response: SearchCriteriaModels.Load.Response(criteria: criteria))
	}

	private func presentLoadError(_ error: Error) {
		presenter?.presentLoadError(error)
	}

	private func presentUpdatedCriteria(_ criteria: SearchCriteria) {
		presenter?.presentCriteria(response: SearchCriteriaModels.UpdateDestination.Response(criteria: criteria))
	}

	private func presentUpdateError(_ error: Error) {
		presenter?.presentUpdateError(error)
	}
}

//
//  HotelsSearchInteractor.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 12/7/25.
//

import Foundation

public final class HotelsSearchInteractor: HotelsSearchBusinessLogic {
	private let criteria: SearchCriteria
	private let worker: HotelsSearchService

	public var presenter: HotelsSearchPresentationLogic?

	public init(
		criteria: SearchCriteria,
		worker: HotelsSearchService
	) {
		self.criteria = criteria
		self.worker = worker
	}

	public func search(request: HotelsSearchModels.Search.Request) {
		worker.search(criteria: criteria) { [weak self] result in
			guard let self else { return }

			switch result {
			case let .success(hotels):
				self.presenter?.presentSearch(response: .init(hotels: hotels))
			case let .failure(error):
				self.presenter?.presentSearchError(error)
			}
		}
	}
}

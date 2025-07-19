//
//  HotelsSearchInteractor.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 12/7/25.
//

import Foundation

public final class HotelsSearchInteractor: HotelsSearchBusinessLogic {
	private let criteria: HotelsSearchCriteria
	private let worker: HotelsSearchService

	public var presenter: HotelsSearchPresentationLogic?

	public init(
		criteria: HotelsSearchCriteria,
		worker: HotelsSearchService
	) {
		self.criteria = criteria
		self.worker = worker
	}

	public func search(request: HotelsSearchModels.Search.Request) {
		presenter?.presentSearchLoading(true)
		worker.search(criteria: criteria) { [weak self] result in
			guard let self else { return }

			self.handleSearchResult(result)
		}
	}

	private func handleSearchResult(_ result: HotelsSearchService.Result) {
		presenter?.presentSearchLoading(false)

		switch result {
		case let .success(hotels):
			presenter?.presentSearch(response: .init(hotels: hotels))
		case let .failure(error):
			presenter?.presentSearchError(error)
		}
	}
}

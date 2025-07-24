//
//  HotelsSearchInteractor.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 12/7/25.
//

import Foundation

public final class HotelsSearchInteractor: HotelsSearchBusinessLogic {
	private let criteria: HotelsSearchCriteria
	private let repository: HotelsRepository
	private var filter = HotelsFilter()

	private let worker: HotelsSearchService
	private var task: HTTPClientTask?

	public var presenter: HotelsSearchPresentationLogic?

	public init(
		criteria: HotelsSearchCriteria,
		repository: HotelsRepository,
		worker: HotelsSearchService
	) {
		self.criteria = criteria
		self.repository = repository
		self.worker = worker
	}

	public func search(request: HotelsSearchModels.Search.Request) {
		presenter?.presentSearchLoading(true)
		task = worker.search(criteria: criteria) { [weak self] result in
			guard let self else { return }

			self.presenter?.presentSearchLoading(false)
			self.handleSearchResult(result)
		}
	}

	private func handleSearchResult(_ result: HotelsSearchService.Result) {
		switch result {
		case let .success(hotels):
			setHotels(hotels)
			presenter?.presentSearch(response: .init(hotels: applyFilter(filter)))
		case let .failure(error):
			presenter?.presentSearchError(error)
		}
	}

	public func cancelSearch() {
		task?.cancel()
	}

	public func filter(request: HotelsSearchModels.Filter.Request) {
		presenter?.presentFilter(response: .init(filter: filter))
	}

	public func updateFilter(request: HotelsSearchModels.UpdateFilter.Request) {
		filter = request.filter
		presenter?.presentUpdateFilter(response: .init(hotels: applyFilter(filter)))
	}

	private func setHotels(_ hotels: [Hotel]) {
		repository.setHotels(hotels)
	}

	private func applyFilter(_ filter: HotelsFilter) -> [Hotel] {
		repository.filter(with: HotelsSpecificationFactory.make(from: filter))
	}
}

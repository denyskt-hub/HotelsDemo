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
	private var filters: HotelFilters

	private let worker: HotelsSearchService
	private var task: HTTPClientTask?

	public var presenter: HotelsSearchPresentationLogic?

	public init(
		criteria: HotelsSearchCriteria,
		filters: HotelFilters,
		repository: HotelsRepository,
		worker: HotelsSearchService
	) {
		self.criteria = criteria
		self.filters = filters
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
			presenter?.presentSearch(response: .init(hotels: applyFilters(filters)))
		case let .failure(error):
			presenter?.presentSearchError(error)
		}
	}

	public func cancelSearch() {
		task?.cancel()
	}

	public func filters(request: HotelsSearchModels.Filter.Request) {
		presenter?.presentFilters(response: .init(filters: filters))
	}

	public func updateFilters(request: HotelsSearchModels.UpdateFilter.Request) {
		filters = request.filters
		presenter?.presentUpdateFilters(
			response: .init(
				hotels: applyFilters(filters),
				hasSelectedFilters: filters.hasSelectedFilters
			)
		)
	}

	private func setHotels(_ hotels: [Hotel]) {
		repository.setHotels(hotels)
	}

	private func applyFilters(_ filters: HotelFilters) -> [Hotel] {
		repository.filter(with: HotelFiltersSpecificationFactory.make(from: filters))
	}
}

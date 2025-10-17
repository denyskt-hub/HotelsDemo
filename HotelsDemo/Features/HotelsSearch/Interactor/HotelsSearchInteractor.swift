//
//  HotelsSearchInteractor.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 12/7/25.
//

import Foundation

public final class HotelsSearchInteractor: HotelsSearchBusinessLogic {
	private let provider: HotelsSearchCriteriaProvider
	private let repository: HotelsRepository
	private var filters: HotelFilters

	private let worker: HotelsSearchService
	private var task: HTTPClientTask?

	public var presenter: HotelsSearchPresentationLogic?

	public init(
		provider: HotelsSearchCriteriaProvider,
		filters: HotelFilters,
		repository: HotelsRepository,
		worker: HotelsSearchService
	) {
		self.provider = provider
		self.filters = filters
		self.repository = repository
		self.worker = worker
	}

	public func handleViewDidAppear(request: HotelsSearchModels.ViewDidAppear.Request) {
		provider.retrieve { [weak self] result in
			guard let self else { return }

			switch result {
			case let .success(criteria):
				self.doSearch(request: .init(criteria: criteria))
			case let .failure(error):
				self.presenter?.presentSearchError(error)
			}
		}
	}

	public func handleViewWillDisappearFromParent(request: HotelsSearchModels.ViewWillDisappearFromParent.Request) {
		doCancelSearch()
	}

	private func doSearch(request: HotelsSearchModels.Search.Request) {
		presenter?.presentSearchLoading(true)
		task = worker.search(criteria: request.criteria) { [weak self] result in
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

	private func doCancelSearch() {
		task?.cancel()
	}

	public func doFetchFilters(request: HotelsSearchModels.FetchFilters.Request) {
		presenter?.presentFilters(response: .init(filters: filters))
	}

	public func handleFilterSelection(request: HotelsSearchModels.FilterSelection.Request) {
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

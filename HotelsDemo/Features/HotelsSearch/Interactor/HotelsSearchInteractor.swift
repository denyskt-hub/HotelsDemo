//
//  HotelsSearchInteractor.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 12/7/25.
//

import Foundation

public final class HotelsSearchInteractor: HotelsSearchBusinessLogic, Sendable {
	private let context: HotelsSearchContext
	private var provider: HotelsSearchCriteriaProvider { context.provider }
	private var worker: HotelsSearchService { context.service }

	private let filtersStore: FiltersStore
	private let repository: HotelsRepository
	private let presenter: HotelsSearchPresentationLogic

	public init(
		context: HotelsSearchContext,
		filters: HotelFilters,
		repository: HotelsRepository,
		presenter: HotelsSearchPresentationLogic
	) {
		self.context = context
		self.filtersStore = FiltersStore(filters)
		self.repository = repository
		self.presenter = presenter
	}

	public func handleViewDidAppear(request: HotelsSearchModels.ViewDidAppear.Request) {
		Task {
			do {
				let criteria = try await provider.retrieve()
				performSearch(request: .init(criteria: criteria))
			} catch {
				await presentSearchError(error)
			}
		}
	}

	public func handleViewWillDisappearFromParent(request: HotelsSearchModels.ViewWillDisappearFromParent.Request) {
		doCancelSearch()
	}

	private let searchTaskStore = TaskStore<Void, Never>()
	private func performSearch(request: HotelsSearchModels.Search.Request) {
		let task = Task {
			await presenter.presentSearchLoading(true)

			do {
				let hotels = try await worker.search(criteria: request.criteria)
				await setHotels(hotels)

				let currentFilters = await currentFilters()
				let filteredHotels = await applyFilters(currentFilters)
				await presenter.presentSearch(response: .init(hotels: filteredHotels))
			} catch {
				await presentSearchError(error)
			}

			await presenter.presentSearchLoading(false)
		}
		Task {
			await searchTaskStore.setTask(task)
		}
	}

	private func doCancelSearch() {
		Task {
			await searchTaskStore.cancel()
		}
	}

	public func doFetchFilters(request: HotelsSearchModels.FetchFilters.Request) {
		Task {
			let currentFilters = await currentFilters()
			await presenter.presentFilters(response: .init(filters: currentFilters))
		}
	}

	public func handleFilterSelection(request: HotelsSearchModels.FilterSelection.Request) {
		Task {
			await setFilters(request.filters)
			await presenter.presentUpdateFilters(
				response: .init(
					hotels: await applyFilters(request.filters),
					hasSelectedFilters: request.filters.hasSelectedFilters
				)
			)
		}
	}

	private func setFilters(_ filters: HotelFilters) async {
		await filtersStore.setFilters(filters)
	}

	private func currentFilters() async -> HotelFilters {
		await filtersStore.getFilters()
	}

	private func setHotels(_ hotels: [Hotel]) async {
		await repository.setHotels(hotels)
	}

	private func applyFilters(_ filters: HotelFilters) async -> [Hotel] {
		await repository.filter(with: HotelFiltersSpecificationFactory.make(from: filters))
	}

	private func presentSearchError(_ error: Error) async {
		await presenter.presentSearchError(error)
	}
}

private actor FiltersStore {
	private var filters: HotelFilters

	init(_ filters: HotelFilters) {
		self.filters = filters
	}

	func getFilters() -> HotelFilters {
		filters
	}

	func setFilters(_ filters: HotelFilters) {
		self.filters = filters
	}
}

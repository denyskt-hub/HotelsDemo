//
//  HotelsSearchInteractor.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 12/7/25.
//

import Foundation
import Synchronization

public final class HotelsSearchInteractor: HotelsSearchBusinessLogic, Sendable {
	private let context: HotelsSearchContext
	private var provider: HotelsSearchCriteriaProvider { context.provider }
	private var worker: HotelsSearchService { context.service }

	private let filtersStore: FiltersStore
	private let repository: HotelsRepository
	private let presenter: HotelsSearchPresentationLogic

	/// Owns the whole "retrieve criteria → search" flow, not just the network
	/// call. Cancel-previous and store-new run inside a single `Mutex` critical
	/// section, so a cancel can never overtake the task it is meant to cancel.
	private let searchTask = Mutex<Task<Void, Never>?>(nil)

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
		searchTask.withLock { task in
			task?.cancel()
			task = Task { [self] in
				do {
					let criteria = try await provider.retrieve()

					// The criteria still arrive after the user has left: the
					// store completes regardless of cancellation. Stop here
					// instead of starting a search nobody is waiting for.
					guard !Task.isCancelled else { return }

					await performSearch(request: .init(criteria: criteria))
				} catch {
					await presentSearchError(error)
				}
			}
		}
	}

	public func handleViewWillDisappearFromParent(request: HotelsSearchModels.ViewWillDisappearFromParent.Request) {
		doCancelSearch()
	}

	private func performSearch(request: HotelsSearchModels.Search.Request) async {
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

	private func doCancelSearch() {
		searchTask.withLock { task in
			task?.cancel()
			task = nil
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

	/// Cancellation is the caller's own intent — the user left the screen — so
	/// it is silenced instead of being surfaced as a failed search.
	private func presentSearchError(_ error: Error) async {
		guard !Task.isCancelled else { return }

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

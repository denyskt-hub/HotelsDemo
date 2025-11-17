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

	private let filters: Mutex<HotelFilters>
	private let repository: HotelsRepository
	private let presenter: HotelsSearchPresentationLogic

	public init(
		context: HotelsSearchContext,
		filters: HotelFilters,
		repository: HotelsRepository,
		presenter: HotelsSearchPresentationLogic
	) {
		self.context = context
		self.filters = Mutex(filters)
		self.repository = repository
		self.presenter = presenter
	}

	public func handleViewDidAppear(request: HotelsSearchModels.ViewDidAppear.Request) {
		Task {
			do {
				let criteria = try await provider.retrieve()
				self.performSearch(request: .init(criteria: criteria))
			} catch {
				await self.presentSearchError(error)
			}
		}
	}

	public func handleViewWillDisappearFromParent(request: HotelsSearchModels.ViewWillDisappearFromParent.Request) {
		doCancelSearch()
	}

	private let currentSearchTask = Mutex<Task<Void, Never>?>(nil)
	private func performSearch(request: HotelsSearchModels.Search.Request) {
		currentSearchTask.withLock { task in
			task?.cancel()
			task = Task {
				await presenter.presentSearchLoading(true)

				do {
					let hotels = try await worker.search(criteria: request.criteria)
					setHotels(hotels)
					await presenter.presentSearch(response: .init(hotels: applyFilters(filters.withLock({ $0 }))))
				} catch {
					await presentSearchError(error)
				}

				await presenter.presentSearchLoading(false)
			}
		}
	}

	private func doCancelSearch() {
		currentSearchTask.withLock { $0?.cancel() }
	}

	public func doFetchFilters(request: HotelsSearchModels.FetchFilters.Request) {
		Task {
			await presenter.presentFilters(response: .init(filters: filters.withLock({ $0 })))
		}
	}

	public func handleFilterSelection(request: HotelsSearchModels.FilterSelection.Request) {
		Task {
			filters.withLock { $0 = request.filters }
			await presenter.presentUpdateFilters(
				response: .init(
					hotels: applyFilters(request.filters),
					hasSelectedFilters: request.filters.hasSelectedFilters
				)
			)
		}
	}

	private func setHotels(_ hotels: [Hotel]) {
		repository.setHotels(hotels)
	}

	private func applyFilters(_ filters: HotelFilters) -> [Hotel] {
		repository.filter(with: HotelFiltersSpecificationFactory.make(from: filters))
	}

	private func presentSearchError(_ error: Error) async {
		await presenter.presentSearchError(error)
	}
}

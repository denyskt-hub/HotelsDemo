//
//  DestinationPickerInteractor.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 19/6/25.
//

import Foundation

public final class DestinationPickerInteractor: DestinationPickerBusinessLogic, Sendable {
	private let worker: DestinationSearchService
	private let presenter: DestinationPickerPresentationLogic
	private let destinations = DestinationsStore()
	private let debouncer: Debouncer

	public init(
		worker: DestinationSearchService,
		presenter: DestinationPickerPresentationLogic,
		debouncer: Debouncer = DefaultDebouncer(delay: 0.5)
	) {
		self.worker = worker
		self.presenter = presenter
		self.debouncer = debouncer
	}

	public func doSearchDestinations(request: DestinationPickerModels.Search.Request) {
		debouncer.asyncExecute { [weak self] in
			guard let self else { return }
			await self.performSearch(query: request.query)
		}
	}

	public func handleDestinationSelection(request: DestinationPickerModels.DestinationSelection.Request) {
		Task {
			guard let selected = await destinations.get(at: request.index) else { return }

			await presentSelectedDestination(selected)
		}
	}

	private func performSearch(query: String) async {
		let trimmedQuery = query.trimmingCharacters(in: .whitespaces)
		guard !trimmedQuery.isEmpty else {
			await clearSearchResults()
			return
		}

		do {
			let destinations = try await self.worker.search(query: trimmedQuery)
			await self.destinations.update(destinations)
			await self.presentDestinations(destinations)
		} catch is CancellationError {
			Logger.log("Search task was canceled.", level: .info)
		} catch {
			await self.presentSearchError(error)
		}
	}

	private func clearSearchResults() async {
		await destinations.update([])
		await presentDestinations([])
	}

	private func presentSelectedDestination(_ selected: Destination) async {
		await presenter.presentSelectedDestination(
			response: DestinationPickerModels.DestinationSelection.Response(selected: selected)
		)
	}

	private func presentDestinations(_ destinations: [Destination]) async {
		await presenter.presentDestinations(
			response: DestinationPickerModels.Search.Response(destinations: destinations)
		)
	}

	private func presentSearchError(_ error: Error) async {
		await presenter.presentSearchError(error)
	}
}

//
//  DestinationPickerInteractor.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 19/6/25.
//

import Foundation
import Synchronization

public final class DestinationPickerInteractor: DestinationPickerBusinessLogic, Sendable {
	private let worker: DestinationSearchService
	private let presenter: DestinationPickerPresentationLogic
	private let destinations = Mutex<[Destination]>([])
	private let currentSearchTask = Mutex<Task<Void, Never>?>(nil)

	public init(
		worker: DestinationSearchService,
		presenter: DestinationPickerPresentationLogic
	) {
		self.worker = worker
		self.presenter = presenter
	}

	public func doSearchDestinations(request: DestinationPickerModels.Search.Request) {
		performSearch(query: request.query)
	}

	public func handleDestinationSelection(request: DestinationPickerModels.DestinationSelection.Request) {
		let selected: Destination? = destinations.withLock { current in
			guard current.indices.contains(request.index) else { return nil }
			return current[request.index]
		}
		guard let selected else { return }

		Task { await presentSelectedDestination(selected) }
	}

	private func performSearch(query: String) {
		let trimmedQuery = query.trimmingCharacters(in: .whitespaces)
		guard !trimmedQuery.isEmpty else {
			clearSearchResults()
			return
		}

		currentSearchTask.withLock { task in
			task?.cancel()
			task = Task { [weak self] in
				guard let self else { return }

				do {
					let destinations = try await self.worker.search(query: trimmedQuery)
					self.destinations.withLock { value in value = destinations }
					await self.presentDestinations(destinations)
				} catch is CancellationError {
					// Ignore
				} catch {
					await self.presentSearchError(error)
				}
			}
		}
	}

	private func clearSearchResults() {
		destinations.withLock { $0 = [] }
		Task { await presentDestinations([]) }
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

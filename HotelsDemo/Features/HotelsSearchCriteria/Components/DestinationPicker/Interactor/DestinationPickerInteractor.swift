//
//  DestinationPickerInteractor.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 19/6/25.
//

import Foundation

public final class DestinationPickerInteractor: DestinationPickerBusinessLogic {
	private let worker: DestinationSearchService
	private let presenter: DestinationPickerPresentationLogic
	private var destinations = [Destination]()

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
		guard destinations.indices.contains(request.index) else { return }

		let selected = destinations[request.index]
		presenter.presentSelectedDestination(
			response: DestinationPickerModels.DestinationSelection.Response(selected: selected)
		)
	}

	private func performSearch(query: String) {
		let trimmedQuery = query.trimmingCharacters(in: .whitespaces)
		guard !trimmedQuery.isEmpty else {
			destinations = []
			presentDestinations([])
			return
		}

		worker.search(query: query) { [weak self] result in
			guard let self = self else { return }

			switch result {
			case let .success(destinations):
				self.destinations = destinations
				self.presentDestinations(destinations)
			case let .failure(error):
				self.presentSearchError(error)
			}
		}
	}

	private func presentDestinations(_ destinations: [Destination]) {
		presenter.presentDestinations(
			response: DestinationPickerModels.Search.Response(destinations: destinations)
		)
	}

	private func presentSearchError(_ error: Error) {
		presenter.presentSearchError(error)
	}
}

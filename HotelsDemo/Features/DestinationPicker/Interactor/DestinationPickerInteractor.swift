//
//  DestinationPickerInteractor.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 19/6/25.
//

import Foundation

final class DestinationPickerInteractor: DestinationPickerBusinessLogic {
	private let worker: DestinationSearchService
	private let debouncer = Debouncer(delay: 0.5)
	private var destinations = [Destination]()

	var presenter: DestinationPickerPresentationLogic?

	init(worker: DestinationSearchService) {
		self.worker = worker
	}

	func searchDestinations(request: DestinationPickerModels.Search.Request) {
		debouncer.execute { [weak self] in
			self?.performSearch(query: request.query)
		}
	}

	private func performSearch(query: String) {
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

	func selectDestination(request: DestinationPickerModels.Select.Request) {
		guard destinations.indices.contains(request.index) else { return }

		let selected = destinations[request.index]
		presenter?.presentSelectedDestination(
			response: DestinationPickerModels.Select.Response(selected: selected)
		)
	}

	private func presentDestinations(_ destinations: [Destination]) {
		presenter?.presentDestinations(
			response: DestinationPickerModels.Search.Response(destinations: destinations)
		)
	}

	private func presentSearchError(_ error: Error) {
		presenter?.presentSearchError(error)
	}
}

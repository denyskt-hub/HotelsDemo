//
//  DestinationPickerInteractor.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 19/6/25.
//

import Foundation

public final class DestinationPickerInteractor: DestinationPickerBusinessLogic {
	private let worker: DestinationSearchService
	private let debouncer: Debouncer
	private var destinations = [Destination]()

	public var presenter: DestinationPickerPresentationLogic?

	public init(
		worker: DestinationSearchService,
		debouncer: Debouncer
	) {
		self.worker = worker
		self.debouncer = debouncer
	}

	public func searchDestinations(request: DestinationPickerModels.Search.Request) {
		debouncer.execute { [weak self] in
			self?.performSearch(query: request.query)
		}
	}

	public func selectDestination(request: DestinationPickerModels.Select.Request) {
		guard destinations.indices.contains(request.index) else { return }

		let selected = destinations[request.index]
		presenter?.presentSelectedDestination(
			response: DestinationPickerModels.Select.Response(selected: selected)
		)
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

	private func presentDestinations(_ destinations: [Destination]) {
		presenter?.presentDestinations(
			response: DestinationPickerModels.Search.Response(destinations: destinations)
		)
	}

	private func presentSearchError(_ error: Error) {
		presenter?.presentSearchError(error)
	}
}

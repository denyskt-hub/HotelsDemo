//
//  DestinationPickerInteractor.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 19/6/25.
//

import Foundation

protocol DestinationPickerBusinessLogic {
	func searchDestinations(request: DestinationPickerModels.Search.Request)
	func selectDestination(request: DestinationPickerModels.Select.Request)
}

final class DestinationPickerInteractor: DestinationPickerBusinessLogic {
	private let worker: DestinationSearchService
	private let debouncer = Debouncer(delay: 0.3)
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
				self.presenter?.presentDestinations(
					response: DestinationPickerModels.Search.Response(destinations: destinations)
				)
			case let .failure(error):
				print(error)
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
}

protocol DestinationSearchService {
	typealias Result = Swift.Result<[Destination], Error>

	func search(query: String, completion: @escaping (Result) -> Void)
}

final class DestinationSearchWorker: DestinationSearchService {
	private let dispatcher: Dispatcher

	init(dispatcher: Dispatcher) {
		self.dispatcher = dispatcher
	}

	func search(query: String, completion: @escaping (DestinationSearchService.Result) -> Void) {
		DispatchQueue.global().asyncAfter(deadline: .now() + 2) { [weak self] in
			self?.dispatcher.dispatch {
				completion(.success([
					Destination(id: 1, type: "city", name: "London", label: "London, United Kingdom", country: "United Kingdom", cityName: "London"),
					Destination(id: 2, type: "district", name: "Manhattan", label: "New York, Manhattan, USA", country: "USA", cityName: "New York")
				]))
			}
		}
	}
}

final class Debouncer {
	private var workItem: DispatchWorkItem?
	private let queue: DispatchQueue
	private let delay: TimeInterval

	init(delay: TimeInterval, queue: DispatchQueue = .main) {
		self.delay = delay
		self.queue = queue
	}

	func execute(_ action: @escaping () -> Void) {
		workItem?.cancel()
		workItem = DispatchWorkItem(block: action)
		if let item = workItem {
			queue.asyncAfter(deadline: .now() + delay, execute: item)
		}
	}
}

public protocol Dispatcher {
	func dispatch(_ action: @escaping () -> Void)
}

public final class ImmediateDispatcher: Dispatcher {
	public func dispatch(_ action: @escaping () -> Void) {
		action()
	}
}

public final class QueueDispatcher: Dispatcher {
	private let queue: DispatchQueue

	public init(queue: DispatchQueue) {
		self.queue = queue
	}

	public func dispatch(_ action: @escaping () -> Void) {
		queue.async { action() }
	}
}

public final class MainQueueDispatcher: Dispatcher {
	private let dispatcher = QueueDispatcher(queue: .main)

	public func dispatch(_ completion: @escaping () -> Void) {
		dispatcher.dispatch(completion)
	}
}

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
				self.presenter?.presentDestinations(
					response: DestinationPickerModels.Search.Response(destinations: destinations)
				)
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

	private func presentSearchError(_ error: Error) {
		presenter?.presentSearchError(error)
	}
}

protocol DestinationSearchService {
	typealias Result = Swift.Result<[Destination], Error>

	func search(query: String, completion: @escaping (Result) -> Void)
}

final class DestinationSearchWorker: DestinationSearchService {
	private let url: URL
	private let client: HTTPClient
	private let dispatcher: Dispatcher

	init(
		url: URL,
		client: HTTPClient,
		dispatcher: Dispatcher
	) {
		self.url = url
		self.client = client
		self.dispatcher = dispatcher
	}

	func search(query: String, completion: @escaping (DestinationSearchService.Result) -> Void) {
		let request = makeRequest(url: url, query: query)

		client.perform(request) { [weak self] result in
			guard let self else { return }

			switch result {
			case let .success((data, response)):
				do {
					let destinations = try DestinationsResponseMapper.map(data, response)
					self.dispatcher.dispatch {
						completion(.success(destinations))
					}
				} catch {
					self.dispatcher.dispatch {
						completion(.failure(error))
					}
				}

			case let .failure(error):
				self.dispatcher.dispatch {
					completion(.failure(error))
				}
			}
		}
	}

	private func makeRequest(url: URL, query: String) -> URLRequest {
		let finalURL = url.appending(queryItems: [URLQueryItem(name: "query", value: query)])
		var request = URLRequest(url: finalURL)
		request.httpMethod = "GET"
		request.allHTTPHeaderFields = [
			"X-RapidAPI-Host": "booking-com15.p.rapidapi.com",
			"X-RapidAPI-Key": "a4b21b3fb5msh31791a7b625be6fp108a10jsn7cbd1a76c613"
		]
		return request
	}
}

enum HTTPError: Error {
	case unexpectedStatusCode(Int)
}

final class DestinationsResponseMapper {
	private struct Response: Decodable {
		private var data: [RemoteDestination]

		var models: [Destination] {
			data.map {
				Destination(
					id: $0.id,
					type: $0.type,
					name: $0.name,
					label: $0.label,
					country: $0.country,
					cityName: $0.cityName
				)
			}
		}
	}

	private struct RemoteDestination: Decodable {
		enum CodingKeys: String, CodingKey {
			case id = "dest_id"
			case type = "dest_type"
			case name
			case label
			case country
			case cityName = "city_name"
		}

		let id: Int
		let type: String
		let name: String
		let label: String
		let country: String
		let cityName: String

		init(from decoder: Decoder) throws {
			let container = try decoder.container(keyedBy: CodingKeys.self)
			self.id = Int(try container.decode(String.self, forKey: .id))!
			self.type = try container.decode(String.self, forKey: .type)
			self.name = try container.decode(String.self, forKey: .name)
			self.label = try container.decode(String.self, forKey: .label)
			self.country = try container.decode(String.self, forKey: .country)
			self.cityName = try container.decode(String.self, forKey: .cityName)
		}
	}

	static func map(_ data: Data, _ response: HTTPURLResponse) throws -> [Destination] {
		guard response.isOK else {
			throw HTTPError.unexpectedStatusCode(response.statusCode)
		}
		
		let result = try JSONDecoder().decode(Response.self, from: data)
		return result.models
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

//
//  DestinationSearchWorker.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 24/6/25.
//

import Foundation

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

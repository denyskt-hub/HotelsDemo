//
//  DestinationSearchWorker.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 24/6/25.
//

import Foundation

public final class DestinationSearchWorker: DestinationSearchService {
	private let url: URL
	private let client: HTTPClient
	private let dispatcher: Dispatcher

	public init(
		url: URL,
		client: HTTPClient,
		dispatcher: Dispatcher
	) {
		self.url = url
		self.client = client
		self.dispatcher = dispatcher
	}

	public func search(query: String, completion: @escaping (DestinationSearchService.Result) -> Void) {
		precondition(!query.trimmingCharacters(in: .whitespaces).isEmpty, "Query must not be empty")

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
		request.setValue(Environment.apiHost, forHTTPHeaderField: Headers.rapidAPIHost)
		request.setValue(Environment.apiKey, forHTTPHeaderField: Headers.rapidAPIKey)
		return request
	}
}

private enum Headers {
	static let rapidAPIHost = "X-RapidAPI-Host"
	static let rapidAPIKey = "X-RapidAPI-Key"
}

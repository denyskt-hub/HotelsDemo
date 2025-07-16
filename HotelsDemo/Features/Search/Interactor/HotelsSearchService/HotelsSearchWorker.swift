//
//  HotelsSearchWorker.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 12/7/25.
//

import Foundation

public final class HotelsSearchWorker: HotelsSearchService {
	private let client: HTTPClient
	private let dispatcher: Dispatcher

	public init(
		client: HTTPClient,
		dispatcher: Dispatcher
	) {
		self.client = client
		self.dispatcher = dispatcher
	}

	public func search(criteria: SearchCriteria, completion: @escaping (HotelsSearchService.Result) -> Void) {
		let request = makeSearchRequest(criteria: criteria)

		client.perform(request) { [weak self] result in
			guard let self else { return }

			let searchResult = HotelsSearchService.Result {
				switch result {
				case let .success((data, response)):
					return try HotelsSearchResponseMapper.map(data, response)
				case let .failure(error):
					throw error
				}
			}

			self.dispatcher.dispatch {
				completion(searchResult)
			}
		}
	}

	private func makeSearchRequest(criteria: SearchCriteria) -> URLRequest {
		guard let destination = criteria.destination else {
			preconditionFailure("Destination is required")
		}

		let url = URL(string: "https://booking-com15.p.rapidapi.com/api/v1/hotels/searchHotels")!

		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd"

		let checkInDate = dateFormatter.string(from: criteria.checkInDate)
		let checkOutDate = dateFormatter.string(from: criteria.checkOutDate)
		let childrenAge = criteria.childrenAge.map({ String($0) }).joined(separator: ",")

		let urlString = url.absoluteString.appending("?dest_id=\(destination.id)&search_type=\(destination.type)&arrival_date=\(checkInDate)&departure_date=\(checkOutDate)&adults=\(criteria.adults)&children_age=\(childrenAge)&room_qty=\(criteria.roomsQuantity)")
		let finalURL = URL(string: urlString)!

		var request = URLRequest(url: finalURL)
		request.httpMethod = "GET"
		return request
	}
}

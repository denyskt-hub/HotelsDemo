//
//  HotelsRequestFactory.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 16/7/25.
//

import Foundation

public protocol HotelsRequestFactory {
	func makeSearchRequest(criteria: SearchCriteria) -> URLRequest
}

public final class DefaultHotelsRequestFactory: HotelsRequestFactory {
	private let url: URL

	private let dateFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy-MM-dd"
		return formatter
	}()

	public init(url: URL) {
		self.url = url
	}

	public func makeSearchRequest(criteria: SearchCriteria) -> URLRequest {
		guard let destination = criteria.destination else {
			preconditionFailure("Destination is required")
		}

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

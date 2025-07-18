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
		let queryParams = makeQueryParams(from: criteria, dateFormatter: dateFormatter)
		let queryString = queryParams.map({ "\($0)=\($1)" }).joined(separator: "&")
		let urlString = url.absoluteString.appending("?\(queryString)")
		let finalURL = URL(string: urlString)!

		var request = URLRequest(url: finalURL)
		request.httpMethod = "GET"
		return request
	}

	private func makeQueryParams(
		from criteria: SearchCriteria,
		dateFormatter: DateFormatter
	) -> [String: String] {
		guard let destination = criteria.destination else {
			preconditionFailure("Destination is required")
		}

		let childrenAge = criteria.childrenAge.map({ String($0) }).joined(separator: ",")
		let encodedChildrenAge = childrenAge.addingPercentEncoding(withAllowedCharacters: .strictQueryValueAllowed) ?? ""

		return [
			"dest_id": "\(destination.id)",
			"search_type": destination.type ,
			"arrival_date": dateFormatter.string(from: criteria.checkInDate),
			"departure_date": dateFormatter.string(from: criteria.checkOutDate),
			"adults": "\(criteria.adults)",
			"children_age": encodedChildrenAge,
			"room_qty": "\(criteria.roomsQuantity)"
		]
	}
}

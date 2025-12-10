//
//  HotelsRequestFactory.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 16/7/25.
//

import Foundation

public enum RequestFactoryError: Error {
	case invalidURL
}

public enum HotelsRequestFactoryError: Error {
	case missingDestination
}

public protocol HotelsRequestFactory: Sendable {
	func makeSearchRequest(criteria: HotelsSearchCriteria) throws -> URLRequest
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

	public func makeSearchRequest(criteria: HotelsSearchCriteria) throws -> URLRequest {
		guard let destination = criteria.destination else {
			throw HotelsRequestFactoryError.missingDestination
		}

		var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
		components?.queryItems = [
			.init(name: "dest_id", value: "\(destination.id)"),
			.init(name: "search_type", value: destination.type),
			.init(name: "arrival_date", value: dateFormatter.string(from: criteria.checkInDate)),
			.init(name: "departure_date", value: dateFormatter.string(from: criteria.checkOutDate)),
			.init(name: "adults", value: "\(criteria.adults)"),
			.init(name: "children_age", value: criteria.childrenAge.map({ String($0) }).joined(separator: ",")),
			.init(name: "room_qty", value: "\(criteria.roomsQuantity)")
		]

		guard let finalURL = components?.url else {
			throw RequestFactoryError.invalidURL
		}

		var request = URLRequest(url: finalURL)
		request.httpMethod = "GET"
		return request
	}
}

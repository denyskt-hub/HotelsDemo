//
//  DestinationsRequestFactory.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 16/7/25.
//

import Foundation

public protocol DestinationsRequestFactory: Sendable {
	func makeSearchRequest(query: String) throws -> URLRequest
}

public final class DefaultDestinationRequestFactory: DestinationsRequestFactory {
	private let url: URL

	public init(url: URL) {
		self.url = url
	}

	public func makeSearchRequest(query: String) throws -> URLRequest {
		let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .strictQueryValueAllowed) ?? ""
		let urlString = url.absoluteString.appending("?query=\(encodedQuery)")

		guard let finalURL = URL(string: urlString) else {
			throw RequestFactoryError.invalidURL
		}

		var request = URLRequest(url: finalURL)
		request.httpMethod = "GET"
		return request
	}
}

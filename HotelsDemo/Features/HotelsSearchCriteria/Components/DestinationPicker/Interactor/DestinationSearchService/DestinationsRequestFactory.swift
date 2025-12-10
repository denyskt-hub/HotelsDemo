//
//  DestinationsRequestFactory.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 16/7/25.
//

import Foundation

public enum DestinationsRequestFactoryError: Error {
	case encodingFailed
}

public protocol DestinationsRequestFactory: Sendable {
	func makeSearchRequest(query: String) throws -> URLRequest
}

public final class DefaultDestinationRequestFactory: DestinationsRequestFactory {
	private let url: URL

	public init(url: URL) {
		self.url = url
	}

	public func makeSearchRequest(query: String) throws -> URLRequest {
		guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .strictQueryValueAllowed) else {
			throw DestinationsRequestFactoryError.encodingFailed
		}

		var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
		components?.percentEncodedQueryItems = [
			URLQueryItem(name: "query", value: encodedQuery)
		]

		guard let finalURL = components?.url else {
			throw RequestFactoryError.invalidURL
		}

		var request = URLRequest(url: finalURL)
		request.httpMethod = "GET"
		return request
	}
}

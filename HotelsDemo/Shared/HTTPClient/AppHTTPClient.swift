//
//  AppHTTPClient.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 11.02.2026.
//

import Foundation

public final class AppHTTPClient: HTTPClient {
	private let decoratee: HTTPClient

	public init(decoratee: HTTPClient) {
		self.decoratee = decoratee
	}

	public func perform(_ request: URLRequest) async throws -> (Data, HTTPURLResponse) {
		do {
			let (data, httpResponse) = try await decoratee.perform(request)

			guard httpResponse.isSuccess else {
				throw AppError.http(.unexpectedStatusCode(httpResponse.statusCode))
			}

			return (data, httpResponse)
		} catch {
			throw AppErrorMapper.map(error)
		}
	}
}

struct AppErrorMapper {
	static func map(_ error: Error) -> Error {
		if let urlError = error as? URLError {
			return mapURLError(urlError)
		}

		return error
	}

	private static func mapURLError(_ error: URLError) -> AppError {
		switch error.code {
		case .notConnectedToInternet, .networkConnectionLost:
			return .network(.noInternet)

		case .cannotConnectToHost:
			return .network(.cannotConnect)

		default:
			return .network(.unknown(error))
		}
	}
}

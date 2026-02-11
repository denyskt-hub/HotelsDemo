//
//  AppError.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 11.02.2026.
//

import Foundation

public enum AppError: Error {
	case network(NetworkError)
	case http(HTTPError)
	case api(APIError)
}

extension AppError: LocalizedError {
	public var errorDescription: String? {
		switch self {
		case .network(let error):
			return error.localizedDescription

		case .http(let error):
			return error.localizedDescription

		case .api(let error):
			return error.localizedDescription
		}
	}
}

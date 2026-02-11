//
//  NetworkError.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 11.02.2026.
//

import Foundation

public enum NetworkError: Error {
	case noInternet
	case cannotConnect
	case unknown(Error)
}

extension NetworkError: LocalizedError {
	public var errorDescription: String? {
		switch self {
		case .noInternet:
			return "No internet connection"

		case .cannotConnect:
			return "Couldn't connect to the server"

		case .unknown:
			return "Unknown network error"
		}
	}
}

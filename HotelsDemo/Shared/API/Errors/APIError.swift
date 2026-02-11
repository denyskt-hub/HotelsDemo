//
//  APIError.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 25/6/25.
//

import Foundation

public enum APIError: Error {
	case serverError(String)
	case decoding(Error)
}

extension APIError: LocalizedError {
	public var errorDescription: String? {
		switch self {
		case .serverError(let message):
			return message

		case .decoding:
			return "Failed to process server response"
		}
	}
}

//
//  HTTPError.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 25/6/25.
//

import Foundation

public enum HTTPError: Error {
	case unexpectedStatusCode(Int)
}

extension HTTPError: LocalizedError {
	public var errorDescription: String? {
		switch self {
		case .unexpectedStatusCode:
			return "Unexpected HTTP status code"
		}
	}
}

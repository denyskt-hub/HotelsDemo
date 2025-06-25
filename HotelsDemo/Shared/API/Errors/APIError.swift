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

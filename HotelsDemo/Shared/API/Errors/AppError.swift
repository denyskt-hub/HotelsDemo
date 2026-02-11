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

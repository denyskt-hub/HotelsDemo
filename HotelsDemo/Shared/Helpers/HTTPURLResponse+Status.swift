//
//  Status.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 20/6/25.
//

import Foundation

public extension HTTPURLResponse {
	private enum Status: Int {
		case ok = 200
		case unauthorized = 401
	}

	var isOK: Bool {
		statusCode == Status.ok.rawValue
	}

	var isUnauthorized: Bool {
		statusCode == Status.unauthorized.rawValue
	}
}

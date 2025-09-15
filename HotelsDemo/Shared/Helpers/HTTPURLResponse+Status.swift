//
//  Status.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 20/6/25.
//

import Foundation

public extension HTTPURLResponse {
	private enum Status {
		static let successRange = 200...299
		static let ok = 200
		static let unauthorizedCode = 401
	}

	var isSuccess: Bool {
		Status.successRange.contains(statusCode)
	}

	var isOK: Bool {
		statusCode == Status.ok
	}

	var isUnauthorized: Bool {
		statusCode == Status.unauthorizedCode
	}
}

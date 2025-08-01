//
//  TestError.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 27/7/25.
//

import Foundation

struct TestError: Error {
	let message: String

	init(_ message: String) {
		self.message = message
	}
}

extension TestError: LocalizedError {
	var errorDescription: String? { message }
}

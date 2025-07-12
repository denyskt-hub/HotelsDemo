//
//  APIResponse.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 25/6/25.
//

import Foundation

public struct APIResponse<T: Decodable>: Decodable {
	public let status: Bool
	public let message: String
	public let data: T
}

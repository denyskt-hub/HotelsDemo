//
//  APIResponseMapper.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 25/6/25.
//

import Foundation

public enum APIResponseMapper {
	public static func map<T: Decodable>(
		_ data: Data,
		_ response: HTTPURLResponse
	) throws -> T {
		guard response.isSuccess else {
			throw HTTPError.unexpectedStatusCode(response.statusCode)
		}

		do {
			let apiResponse = try JSONDecoder().decode(APIResponse<T>.self, from: data)

			guard apiResponse.status else {
				throw APIError.serverError(apiResponse.message)
			}

			return apiResponse.data
		} catch {
			Logger.log("Decoding error: \(error)", level: .error, tag: .networking)
			Logger.log("Raw response: \(String(data: data, encoding: .utf8) ?? "Invalid UTF-8")", level: .debug, tag: .networking)
			throw APIError.decoding(error)
		}
	}
}

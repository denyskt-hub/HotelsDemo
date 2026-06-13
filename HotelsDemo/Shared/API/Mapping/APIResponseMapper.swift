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
		let apiResponse: APIResponse<T>
		do {
			apiResponse = try JSONDecoder().decode(APIResponse<T>.self, from: data)
		} catch {
			// Only decoding failures belong here — keep the server-error throw
			// below outside the `do`, or this `catch` would swallow it and
			// mislabel a `status: false` response as a decoding error.
			Logger.log("Decoding error: \(error)", level: .error, tag: .networking)
			Logger.log("Raw response: \(SensitiveDataRedactor.redactedBody(data))", level: .debug, tag: .networking)
			throw AppError.api(.decoding(error))
		}

		guard apiResponse.status else {
			throw AppError.api(.serverError(apiResponse.message))
		}

		return apiResponse.data
	}
}

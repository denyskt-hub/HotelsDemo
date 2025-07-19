//
//  ImageDataMapper.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 15/7/25.
//

import Foundation

public final class ImageDataMapper {
	public enum Error: Swift.Error {
		case invalidData
	}

	public static func map(_ data: Data, _ response: HTTPURLResponse) throws -> Data {
		guard response.isOK else {
			throw HTTPError.unexpectedStatusCode(response.statusCode)
		}
		guard !data.isEmpty else {
			throw Error.invalidData
		}

		return data
	}
}

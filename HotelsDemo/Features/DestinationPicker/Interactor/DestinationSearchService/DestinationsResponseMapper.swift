//
//  DestinationsResponseMapper.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 24/6/25.
//

import Foundation

final class DestinationsResponseMapper {
	struct RemoteDestination: Decodable {
		enum CodingKeys: String, CodingKey {
			case id = "dest_id"
			case type = "dest_type"
			case name
			case label
			case country
			case cityName = "city_name"
		}

		let id: Int
		let type: String
		let name: String
		let label: String
		let country: String
		let cityName: String

		init(from decoder: Decoder) throws {
			let container = try decoder.container(keyedBy: CodingKeys.self)
			self.id = Int(try container.decode(String.self, forKey: .id))!
			self.type = try container.decode(String.self, forKey: .type)
			self.name = try container.decode(String.self, forKey: .name)
			self.label = try container.decode(String.self, forKey: .label)
			self.country = try container.decode(String.self, forKey: .country)
			self.cityName = try container.decode(String.self, forKey: .cityName)
		}
	}

	static func map(_ data: Data, _ response: HTTPURLResponse) throws -> [Destination] {
		guard response.isOK else {
			throw HTTPError.unexpectedStatusCode(response.statusCode)
		}

		let apiResponse = try JSONDecoder().decode(APIResponse<[RemoteDestination]>.self, from: data)

		guard apiResponse.status else {
			throw APIError.message(apiResponse.message)
		}

		return apiResponse.data.models
	}
}

extension Array where Element == DestinationsResponseMapper.RemoteDestination {
	var models: [Destination] {
		map {
			Destination(
				id: $0.id,
				type: $0.type,
				name: $0.name,
				label: $0.label,
				country: $0.country,
				cityName: $0.cityName
			)
		}
	}
}

enum APIError: Error {
	case message(String)
}

enum HTTPError: Error {
	case unexpectedStatusCode(Int)
}

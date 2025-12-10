//
//  DestinationsResponseMapper.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 24/6/25.
//

import Foundation

public enum DestinationsResponseMapper {
	struct RemoteDestination: Decodable {
		enum MappingError: Error {
			case invalidId(String)
		}
		
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
			let idString = try container.decode(String.self, forKey: .id)
			guard let id = Int(idString) else { throw MappingError.invalidId(idString) }
			self.id = id
			self.type = try container.decode(String.self, forKey: .type)
			self.name = try container.decode(String.self, forKey: .name)
			self.label = try container.decode(String.self, forKey: .label)
			self.country = try container.decode(String.self, forKey: .country)
			self.cityName = try container.decode(String.self, forKey: .cityName)
		}

		func toDomain() -> Destination {
			Destination(
				id: id,
				type: type,
				name: name,
				label: label,
				country: country,
				cityName: cityName
			)
		}
	}

	static func map(_ data: Data, _ response: HTTPURLResponse) throws -> [Destination] {
		let destinations: [RemoteDestination] = try APIResponseMapper.map(data, response)
		return destinations.map { $0.toDomain() }
	}
}

//
//  HotelsSearchResponseMapper.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 16/7/25.
//

import Foundation

public enum HotelsSearchResponseMapper {
	struct RemoteSearchData: Decodable {
		let hotels: [RemoteHotel]
	}

	struct RemoteHotel: Decodable {
		enum CodingKeys: String, CodingKey {
			case property
		}

		enum PropertyCodingKeys: String, CodingKey {
			case id
			case position
			case name
			case starRating = "accuratePropertyClass"
			case reviewCount
			case reviewScore
			case photoURLs = "photoUrls"
			case price = "priceBreakdown"
		}

		enum PriceCodingKeys: String, CodingKey {
			case grossPrice

		}

		enum GrossPriceCodingKeys: String, CodingKey {
			case value
			case currency
		}

		let id: Int
		let position: Int
		let name: String
		let starRating: Int
		let reviewCount: Int
		let reviewScore: Decimal
		let photoURLs: [URL]
		let grossPrice: Decimal
		let currency: String

		init(from decoder: Decoder) throws {
			let container = try decoder.container(keyedBy: CodingKeys.self)

			let propertyContainer = try container.nestedContainer(keyedBy: PropertyCodingKeys.self, forKey: .property)
			self.id = try propertyContainer.decode(Int.self, forKey: .id)
			self.position = try propertyContainer.decode(Int.self, forKey: .position)
			self.name = try propertyContainer.decode(String.self, forKey: .name)
			self.starRating = try propertyContainer.decode(Int.self, forKey: .starRating)
			self.reviewCount = try propertyContainer.decode(Int.self, forKey: .reviewCount)
			self.reviewScore = try propertyContainer.decode(Decimal.self, forKey: .reviewScore)
			self.photoURLs = try propertyContainer.decode([URL].self, forKey: .photoURLs)

			let priceContainer = try propertyContainer.nestedContainer(keyedBy: PriceCodingKeys.self, forKey: .price)
			let grossPriceContainer = try priceContainer.nestedContainer(keyedBy: GrossPriceCodingKeys.self, forKey: .grossPrice)
			self.grossPrice = try grossPriceContainer.decode(Decimal.self, forKey: .value)
			self.currency = try grossPriceContainer.decode(String.self, forKey: .currency)
		}

		func toDomain() -> Hotel {
			Hotel(
				id: id,
				position: position,
				name: name,
				starRating: starRating,
				reviewCount: reviewCount,
				reviewScore: reviewScore,
				photoURLs: photoURLs,
				price: Price(
					grossPrice: grossPrice,
					currency: currency
				)
			)
		}
	}

	static func map(_ data: Data, _ response: HTTPURLResponse) throws -> [Hotel] {
		let searchData: RemoteSearchData = try APIResponseMapper.map(data, response)
		return searchData.hotels.map { $0.toDomain() }
	}
}

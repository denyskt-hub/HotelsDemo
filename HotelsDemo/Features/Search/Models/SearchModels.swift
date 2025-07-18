//
//  SearchModels.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 12/7/25.
//

import Foundation

public enum SearchModels {
	public enum Search {
		public struct Request: Equatable {
			public init() {}
		}

		public struct Response: Equatable {
			public let hotels: [Hotel]

			public init(hotels: [Hotel]) {
				self.hotels = hotels
			}
		}

		public struct ViewModel: Equatable {
			public let hotels: [HotelViewModel]
			
			public init(hotels: [HotelViewModel]) {
				self.hotels = hotels
			}
		}
	}

	public struct HotelViewModel: Equatable {
		public let position: Int
		public let starRating: Int
		public let name: String
		public let score: String
		public let reviews: String
		public let price: String
		public let priceDetails: String
		public let photoURL: URL?

		public init(
			position: Int,
			starRating: Int,
			name: String,
			score: String,
			reviews: String,
			price: String,
			priceDetails: String,
			photoURL: URL?
		) {
			self.position = position
			self.starRating = starRating
			self.name = name
			self.score = score
			self.reviews = reviews
			self.price = price
			self.priceDetails = priceDetails
			self.photoURL = photoURL
		}
	}

	public struct ErrorViewModel: Equatable {
		public let message: String

		public init(message: String) {
			self.message = message
		}
	}
}

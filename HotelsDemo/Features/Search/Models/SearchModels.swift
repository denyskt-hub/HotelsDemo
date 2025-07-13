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
		public let name: String
		public let position: Int

		public init(name: String, position: Int) {
			self.name = name
			self.position = position
		}
	}

	public struct ErrorViewModel: Equatable {
		public let message: String

		public init(message: String) {
			self.message = message
		}
	}
}

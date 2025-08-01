//
//  HotelFiltersPickerModels.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 25/7/25.
//

import Foundation

public enum HotelFiltersPickerModels {
	public enum Select {
		public struct Request: Equatable {
			public init() {}
		}

		public struct Response: Equatable {
			public let filters: HotelFilters

			public init(filters: HotelFilters) {
				self.filters = filters
			}
		}

		public struct ViewModel: Equatable {
			public let filters: HotelFilters

			public init(filters: HotelFilters) {
				self.filters = filters
			}
		}
	}

	public enum Reset {
		public struct Request: Equatable {
			public init() {}
		}

		public struct Response: Equatable {
			public init() {}
		}

		public struct ViewModel: Equatable {
			public init() {}
		}
	}

	public enum UpdatePriceRange {
		public struct Request: Equatable {
			public let priceRange: ClosedRange<Decimal>?

			public init(priceRange: ClosedRange<Decimal>?) {
				self.priceRange = priceRange
			}
		}
	}

	public enum UpdateStarRatings {
		public struct Request: Equatable {
			public let starRatings: Set<StarRating>

			public init(starRatings: Set<StarRating>) {
				self.starRatings = starRatings
			}
		}
	}

	public enum UpdateReviewScore {
		public struct Request: Equatable {
			public let reviewScore: ReviewScore?

			public init(reviewScore: ReviewScore?) {
				self.reviewScore = reviewScore
			}
		}
	}
}

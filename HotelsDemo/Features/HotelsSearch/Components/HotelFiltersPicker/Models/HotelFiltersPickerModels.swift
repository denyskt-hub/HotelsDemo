//
//  HotelFiltersPickerModels.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 25/7/25.
//

import Foundation

public enum HotelFiltersPickerModels {
	public enum Load {
		public struct Request: Equatable {
			public init() {}
		}

		public struct Response: Equatable {
			public let filter: HotelsFilter

			public init(filter: HotelsFilter) {
				self.filter = filter
			}
		}

		public struct ViewModel: Equatable {
			public let filters: [FilterViewModel]

			public init(filters: [FilterViewModel]) {
				self.filters = filters
			}
		}
	}

	public enum Select {
		public struct Request: Equatable {
			public init() {}
		}

		public struct Response: Equatable {
			public let filter: HotelsFilter

			public init(filter: HotelsFilter) {
				self.filter = filter
			}
		}

		public struct ViewModel: Equatable {
			public let filter: HotelsFilter

			public init(filter: HotelsFilter) {
				self.filter = filter
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
			public let reviewScores: Set<ReviewScore>

			public init(reviewScores: Set<ReviewScore>) {
				self.reviewScores = reviewScores
			}
		}
	}

	public enum FilterViewModel: Equatable {
		case priceRange(option: PriceRangeFilterOptionViewModel)
		case starRating(options: [FilterOptionViewModel<StarRating>])
		case reviewScore(options: [FilterOptionViewModel<ReviewScore>])
	}

	public struct PriceRangeFilterOptionViewModel: Equatable {
		public let minPrice: Decimal
		public let maxPrice: Decimal
		public let currencyCode: String
		public let selectedRange: ClosedRange<Decimal>?

		public init(
			minPrice: Decimal,
			maxPrice: Decimal,
			currencyCode: String,
			selectedRange: ClosedRange<Decimal>?
		) {
			self.minPrice = minPrice
			self.maxPrice = maxPrice
			self.currencyCode = currencyCode
			self.selectedRange = selectedRange
		}
	}

	public struct FilterOptionViewModel<Value: Hashable>: Equatable {
		public let title: String
		public let value: Value
		public let isSelected: Bool

		public init(title: String, value: Value, isSelected: Bool) {
			self.title = title
			self.value = value
			self.isSelected = isSelected
		}
	}
}

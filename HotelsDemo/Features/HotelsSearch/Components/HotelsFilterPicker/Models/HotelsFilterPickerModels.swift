//
//  HotelsFilterPickerModels.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 20/7/25.
//

import Foundation

public enum HotelsFilterPickerModels {
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

	public enum UpdatePriceRange {
		public struct Request: Equatable {
			public let priceRange: ClosedRange<Decimal>

			public init(priceRange: ClosedRange<Decimal>) {
				self.priceRange = priceRange
			}
		}
	}

	public enum UpdateStarRatings {
		public struct Request: Equatable {
			public let starRatings: Set<Int>

			public init(starRatings: Set<Int>) {
				self.starRatings = starRatings
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

	public enum FilterViewModel: Equatable {
		case priceRange(option: PriceRangeFilterOptionViewModel)
		case starRating(options: [FilterOptionViewModel<Int>])
		case reviewScore(options: [FilterOptionViewModel<Decimal>])
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

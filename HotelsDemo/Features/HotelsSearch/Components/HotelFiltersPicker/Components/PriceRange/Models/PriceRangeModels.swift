//
//  PriceRangeModels.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 26/7/25.
//

import Foundation

public enum PriceRangeModels {
	public enum FetchPriceRange {
		public struct Request: Equatable {
			public init() {}
		}

		public struct Response: Equatable {
			public let availablePriceRange: ClosedRange<Decimal>
			public let priceRange: ClosedRange<Decimal>?
			public let currencyCode: String

			public init(
				availablePriceRange: ClosedRange<Decimal>,
				priceRange: ClosedRange<Decimal>?,
				currencyCode: String
			) {
				self.availablePriceRange = availablePriceRange
				self.priceRange = priceRange
				self.currencyCode = currencyCode
			}
		}

		public struct ViewModel: Equatable {
			public let priceRangeViewModel: PriceRangeViewModel

			public init(priceRangeViewModel: PriceRangeViewModel) {
				self.priceRangeViewModel = priceRangeViewModel
			}
		}
	}

	public enum PriceRangeReset {
		public struct Request: Equatable {
			public init() {}
		}

		public struct Response: Equatable {
			public let availablePriceRange: ClosedRange<Decimal>
			public let currencyCode: String

			public init(
				availablePriceRange: ClosedRange<Decimal>,
				currencyCode: String
			) {
				self.availablePriceRange = availablePriceRange
				self.currencyCode = currencyCode
			}
		}

		public struct ViewModel: Equatable {
			public let priceRangeViewModel: PriceRangeViewModel

			public init(priceRangeViewModel: PriceRangeViewModel) {
				self.priceRangeViewModel = priceRangeViewModel
			}
		}
	}

	public enum PriceRangeSelection {
		public struct Request: Equatable {
			public let priceRange: ClosedRange<Decimal>

			public init(priceRange: ClosedRange<Decimal>) {
				self.priceRange = priceRange
			}
		}

		public struct Response: Equatable {
			public let priceRange: ClosedRange<Decimal>

			public init(priceRange: ClosedRange<Decimal>) {
				self.priceRange = priceRange
			}
		}

		public struct ViewModel: Equatable {
			public let priceRange: ClosedRange<Decimal>

			public init(priceRange: ClosedRange<Decimal>) {
				self.priceRange = priceRange
			}
		}
	}

	public enum SelectingPriceRange {
		public struct Request: Equatable {
			public let priceRange: ClosedRange<Decimal>

			public init(priceRange: ClosedRange<Decimal>) {
				self.priceRange = priceRange
			}
		}

		public struct Response: Equatable {
			public let priceRange: ClosedRange<Decimal>
			public let currencyCode: String

			public init(priceRange: ClosedRange<Decimal>, currencyCode: String) {
				self.priceRange = priceRange
				self.currencyCode = currencyCode
			}
		}

		public struct ViewModel: Equatable {
			public let lowerValue: String
			public let upperValue: String

			public init(
				lowerValue: String,
				upperValue: String
			) {
				self.lowerValue = lowerValue
				self.upperValue = upperValue
			}
		}
	}

	public struct PriceRangeViewModel: Equatable {
		public let availablePriceRange: ClosedRange<Decimal>
		public let priceRange: ClosedRange<Decimal>
		public let lowerValue: String
		public let upperValue: String

		public init(
			availablePriceRange: ClosedRange<Decimal>,
			priceRange: ClosedRange<Decimal>,
			lowerValue: String,
			upperValue: String
		) {
			self.availablePriceRange = availablePriceRange
			self.priceRange = priceRange
			self.lowerValue = lowerValue
			self.upperValue = upperValue
		}
	}
}

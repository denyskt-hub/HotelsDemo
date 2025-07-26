//
//  StarRatingModels.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 26/7/25.
//

import Foundation

public enum StarRatingModels {
	public enum Load {
		public struct Request: Equatable {
			public init() {}
		}

		public struct Response: Equatable {
			public let options: [Option]

			public init(options: [Option]) {
				self.options = options
			}
		}

		public struct ViewModel: Equatable {
			public let options: [OptionViewModel]

			public init(options: [OptionViewModel]) {
				self.options = options
			}
		}
	}

	public enum Reset {
		public struct Request: Equatable {
			public init() {}
		}

		public struct Response: Equatable {
			public let options: [Option]

			public init(options: [Option]) {
				self.options = options
			}
		}

		public struct ViewModel: Equatable {
			public let options: [OptionViewModel]

			public init(options: [OptionViewModel]) {
				self.options = options
			}
		}
	}

	public enum Select {
		public struct Request: Equatable {
			public let starRating: StarRating

			public init(starRating: StarRating) {
				self.starRating = starRating
			}
		}

		public struct Response: Equatable {
			public let starRatings: Set<StarRating>
			public let options: [Option]

			public init(starRatings: Set<StarRating>, options: [Option]) {
				self.starRatings = starRatings
				self.options = options
			}
		}

		public struct ViewModel: Equatable {
			public let starRatings: Set<StarRating>
			public let options: [OptionViewModel]

			public init(starRatings: Set<StarRating>, options: [OptionViewModel]) {
				self.starRatings = starRatings
				self.options = options
			}
		}
	}

	public struct Option: Equatable {
		public let value: StarRating
		public let isSelected: Bool
	}

	public struct OptionViewModel: Equatable {
		public let title: String
		public let value: StarRating
		public let isSelected: Bool

		public init(title: String, value: StarRating, isSelected: Bool) {
			self.title = title
			self.value = value
			self.isSelected = isSelected
		}
	}
}

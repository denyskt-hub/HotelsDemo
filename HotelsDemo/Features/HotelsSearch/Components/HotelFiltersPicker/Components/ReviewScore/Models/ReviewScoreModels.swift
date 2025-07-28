//
//  ReviewScoreModels.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 25/7/25.
//

import Foundation

public enum ReviewScoreModels {
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
			public let reviewScore: ReviewScore?

			public init(reviewScore: ReviewScore?) {
				self.reviewScore = reviewScore
			}
		}

		public struct Response: Equatable {
			public let reviewScore: ReviewScore?
			public let options: [Option]

			public init(reviewScore: ReviewScore?, options: [Option]) {
				self.reviewScore = reviewScore
				self.options = options
			}
		}

		public struct ViewModel: Equatable {
			public let reviewScore: ReviewScore?
			public let options: [OptionViewModel]

			public init(reviewScore: ReviewScore?, options: [OptionViewModel]) {
				self.reviewScore = reviewScore
				self.options = options
			}
		}
	}

	public struct Option: Equatable {
		public let value: ReviewScore
		public let isSelected: Bool

		public init(value: ReviewScore, isSelected: Bool) {
			self.value = value
			self.isSelected = isSelected
		}
	}

	public struct OptionViewModel: Equatable {
		public let title: String
		public let value: ReviewScore
		public let isSelected: Bool

		public init(title: String, value: ReviewScore, isSelected: Bool) {
			self.title = title
			self.value = value
			self.isSelected = isSelected
		}
	}
}

public extension ReviewScoreModels.Option {
	static func makeAll(selected: ReviewScore?) -> [Self] {
		ReviewScore.allCases.map {
			.init(value: $0, isSelected: $0 == selected)
		}
	}
}

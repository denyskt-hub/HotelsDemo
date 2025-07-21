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

	public enum FilterViewModel: Equatable {
		case priceRange(min: Decimal, max: Decimal, selected: ClosedRange<Decimal>?)
		case starRating(options: [FilterOptionViewModel<Int>])
		case reviewScore(options: [FilterOptionViewModel<Decimal>])
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

//
//  DestinationPickerModels.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 19/6/25.
//

import Foundation

public enum DestinationPickerModels {
	public enum Search {
		public struct Request {
			public let query: String

			public init(query: String) {
				self.query = query
			}
		}

		public struct Response: Equatable {
			public let destinations: [Destination]

			public init(destinations: [Destination]) {
				self.destinations = destinations
			}
		}

		public struct ViewModel {
			let destinations: [String]
		}

		public struct ErrorViewModel {
			let message: String
		}
	}

	public enum Select {
		public struct Request {
			public let index: Int

			public init(index: Int) {
				self.index = index
			}
		}

		public struct Response: Equatable {
			public let selected: Destination

			public init(selected: Destination) {
				self.selected = selected
			}
		}

		public struct ViewModel {
			let selected: Destination
		}
	}
}

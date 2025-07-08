//
//  DestinationPickerModels.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 19/6/25.
//

import Foundation

public enum DestinationPickerModels {
	public enum Search {
		public struct Request: Equatable {
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

		public struct ViewModel: Equatable {
			public let destinations: [String]

			public init(destinations: [String]) {
				self.destinations = destinations
			}
		}

		public struct ErrorViewModel: Equatable {
			public let message: String

			public init(message: String) {
				self.message = message
			}
		}
	}

	public enum Select {
		public struct Request: Equatable {
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

		public struct ViewModel: Equatable {
			public let selected: Destination

			public init(selected: Destination) {
				self.selected = selected
			}
		}
	}
}

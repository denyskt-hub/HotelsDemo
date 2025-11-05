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
			public let destinations: [DestinationViewModel]

			public init(destinations: [DestinationViewModel]) {
				self.destinations = destinations
			}
		}

		public struct DestinationViewModel: Equatable {
			public let title: String
			public let subtitle: String

			public init(title: String, subtitle: String) {
				self.title = title
				self.subtitle = subtitle
			}
		}

		public struct ErrorViewModel: Equatable {
			public let message: String

			public init(message: String) {
				self.message = message
			}
		}
	}

	public enum DestinationSelection {
		public struct Request: Equatable, Sendable {
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

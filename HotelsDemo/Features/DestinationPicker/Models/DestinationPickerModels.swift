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
			let query: String
		}

		public struct Response {
			let destinations: [Destination]
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
			let index: Int
		}

		public struct Response {
			let selected: Destination
		}

		public struct ViewModel {
			let selected: Destination
		}
	}
}

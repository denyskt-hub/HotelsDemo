//
//  DestinationPickerModels.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 19/6/25.
//

import Foundation

enum DestinationPickerModels {
	enum Search {
		struct Request {
			let query: String
		}

		struct Response {
			let destinations: [Destination]
		}

		struct ViewModel {
			let destinations: [String]
		}

		struct ErrorViewModel {
			let message: String
		}
	}

	enum Select {
		struct Request {
			let index: Int
		}

		struct Response {
			let selected: Destination
		}

		struct ViewModel {
			let selected: Destination
		}
	}
}

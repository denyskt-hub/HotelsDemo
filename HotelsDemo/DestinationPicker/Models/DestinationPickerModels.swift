//
//  DestinationPickerModels.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 19/6/25.
//

import Foundation

enum DestinationPickerModels {
	struct Request {
		let query: String
	}

	struct Response {
		let destinations: [Destination]
	}

	struct ViewModel {
		let destinations: [String]
	}
}

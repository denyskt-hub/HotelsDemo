//
//  SearchCriteriaModels.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 19/6/25.
//

import Foundation

enum SearchCriteriaModels {
	struct Request {}

	struct Response {
		let criteria: SearchCriteria?
	}

	struct ViewModel {
		let destination: String
		let dateRange: String
		let roomGuests: String
	}

	enum UpdateDestination {
		struct Request {
			let destination: Destination
		}
	}
}

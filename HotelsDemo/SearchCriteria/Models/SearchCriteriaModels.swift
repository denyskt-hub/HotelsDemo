//
//  SearchCriteriaModels.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 19/6/25.
//

import Foundation

enum SearchCriteriaModels {
	enum Load {
		struct Request {}
		
		struct Response {
			let criteria: SearchCriteria
		}
		
		struct ViewModel {
			let destination: String?
			let dateRange: String
			let roomGuests: String
		}

		struct ErrorViewModel {
			let message: String
		}
	}

	enum LoadRoomGuests {
		struct Request {}

		struct Response {
			let roomGuests: RoomGuests
		}
	}

	enum UpdateDestination {
		struct Request {
			let destination: Destination
		}

		struct Response {
			let criteria: SearchCriteria
		}

		struct ViewModel {
			let destination: String?
			let dateRange: String
			let roomGuests: String
		}

		struct ErrorViewModel {
			let message: String
		}
	}
}

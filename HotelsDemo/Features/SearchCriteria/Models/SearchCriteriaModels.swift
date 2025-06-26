//
//  SearchCriteriaModels.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 19/6/25.
//

import Foundation

public enum SearchCriteriaModels {
	public enum Load {
		public struct Request {
			public init() {}
		}

		public struct Response {
			let criteria: SearchCriteria
		}
		
		public struct ViewModel {
			let destination: String?
			let dateRange: String
			let roomGuests: String
		}

		public struct ErrorViewModel {
			let message: String
		}
	}

	public enum LoadRoomGuests {
		public struct Request {}

		public struct Response {
			let roomGuests: RoomGuests
		}
	}

	public enum LoadDates {
		public struct Request {}

		public struct Response {
			let checkInDate: Date
			let checkOutDate: Date
		}
	}

	public enum UpdateDestination {
		public struct Request {
			let destination: Destination
		}

		public struct Response {
			let criteria: SearchCriteria
		}

		public struct ViewModel {
			let destination: String?
			let dateRange: String
			let roomGuests: String
		}

		public struct ErrorViewModel {
			let message: String
		}
	}

	public enum UpdateDates {
		public struct Request {
			let checkInDate: Date
			let checkOutDate: Date
		}

		public struct Response {
			let criteria: SearchCriteria
		}
	}

	public enum UpdateRoomGuests {
		public struct Request {
			let rooms: Int
			let adults: Int
			let childrenAge: [Int]
		}

		public struct Response {
			let criteria: SearchCriteria
		}
	}
}

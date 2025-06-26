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

		public struct Response: Equatable {
			public let criteria: SearchCriteria

			public init(criteria: SearchCriteria) {
				self.criteria = criteria
			}
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
		public struct Request {
			public init() {}
		}

		public struct Response: Equatable {
			public let roomGuests: RoomGuests

			public init(roomGuests: RoomGuests) {
				self.roomGuests = roomGuests
			}
		}
	}

	public enum LoadDates {
		public struct Request {
			public init() {}
		}

		public struct Response: Equatable {
			public let checkInDate: Date
			public let checkOutDate: Date

			public init(checkInDate: Date, checkOutDate: Date) {
				self.checkInDate = checkInDate
				self.checkOutDate = checkOutDate
			}
		}
	}

	public enum UpdateDestination {
		public struct Request {
			public let destination: Destination

			public init(destination: Destination) {
				self.destination = destination
			}
		}

		public struct Response: Equatable {
			public let criteria: SearchCriteria

			public init(criteria: SearchCriteria) {
				self.criteria = criteria
			}
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
			public let checkInDate: Date
			public let checkOutDate: Date

			public init(checkInDate: Date, checkOutDate: Date) {
				self.checkInDate = checkInDate
				self.checkOutDate = checkOutDate
			}
		}

		public struct Response: Equatable {
			public let criteria: SearchCriteria

			public init(criteria: SearchCriteria) {
				self.criteria = criteria
			}
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

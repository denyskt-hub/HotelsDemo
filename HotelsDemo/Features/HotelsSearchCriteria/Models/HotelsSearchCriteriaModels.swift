//
//  HotelsSearchCriteriaModels.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 19/6/25.
//

import Foundation

public enum HotelsSearchCriteriaModels {
	public enum Load {
		public struct Request: Equatable {
			public init() {}
		}

		public struct Response: Equatable {
			public let criteria: HotelsSearchCriteria

			public init(criteria: HotelsSearchCriteria) {
				self.criteria = criteria
			}
		}

		public struct ViewModel: Equatable {
			public let destination: String?
			public let dateRange: String
			public let roomGuests: String

			public var isSearchEnabled: Bool {
				destination != nil
			}

			public init(destination: String?, dateRange: String, roomGuests: String) {
				self.destination = destination
				self.dateRange = dateRange
				self.roomGuests = roomGuests
			}
		}
	}

	public enum LoadRoomGuests {
		public struct Request: Equatable {
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
		public struct Request: Equatable {
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
		public struct Request: Equatable {
			public let destination: Destination

			public init(destination: Destination) {
				self.destination = destination
			}
		}

		public struct Response: Equatable {
			public let criteria: HotelsSearchCriteria

			public init(criteria: HotelsSearchCriteria) {
				self.criteria = criteria
			}
		}
	}

	public enum UpdateDates {
		public struct Request: Equatable {
			public let checkInDate: Date
			public let checkOutDate: Date

			public init(checkInDate: Date, checkOutDate: Date) {
				self.checkInDate = checkInDate
				self.checkOutDate = checkOutDate
			}
		}

		public struct Response: Equatable {
			public let criteria: HotelsSearchCriteria

			public init(criteria: HotelsSearchCriteria) {
				self.criteria = criteria
			}
		}
	}

	public enum UpdateRoomGuests {
		public struct Request: Equatable {
			public let rooms: Int
			public let adults: Int
			public let childrenAge: [Int]

			public init(rooms: Int, adults: Int, childrenAge: [Int]) {
				self.rooms = rooms
				self.adults = adults
				self.childrenAge = childrenAge
			}
		}

		public struct Response: Equatable {
			public let criteria: HotelsSearchCriteria

			public init(criteria: HotelsSearchCriteria) {
				self.criteria = criteria
			}
		}
	}

	public enum Search {
		public struct Request: Equatable {
			public init() {}
		}

		public struct Response: Equatable {
			public let criteria: HotelsSearchCriteria

			public init(criteria: HotelsSearchCriteria) {
				self.criteria = criteria
			}
		}

		public struct ViewModel: Equatable {
			public let criteria: HotelsSearchCriteria

			public init(criteria: HotelsSearchCriteria) {
				self.criteria = criteria
			}
		}
	}

	public struct ErrorViewModel: Equatable {
		public let message: String

		public init(message: String) {
			self.message = message
		}
	}
}

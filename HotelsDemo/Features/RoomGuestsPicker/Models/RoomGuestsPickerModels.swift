//
//  RoomGuestsPickerModels.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 20/6/25.
//

import Foundation

public enum RoomGuestsPickerModels {
	public enum Load {
		public struct Request {
			public init() {}
		}

		public struct Response: Equatable {
			public let rooms: Int
			public let adults: Int
			public let childrenAge: [Int]

			public init(rooms: Int, adults: Int, childrenAge: [Int]) {
				self.rooms = rooms
				self.adults = adults
				self.childrenAge = childrenAge
			}
		}

		public struct ViewModel {
			let rooms: Int
			let adults: Int
			let childrenAge: [AgeInputViewModel]
		}
	}

	public enum LoadLimits {
		public struct Request {
			public init() {}
		}

		public struct Response: Equatable {
			public let limits: RoomGuestsLimits

			public init(limits: RoomGuestsLimits) {
				self.limits = limits
			}
		}
	}

	public enum UpdateRooms {
		public struct Request {
			public init() {}
		}

		public struct Response: Equatable {
			public let rooms: Int

			public init(rooms: Int) {
				self.rooms = rooms
			}
		}

		public struct ViewModel {
			public let rooms: Int

			public init(rooms: Int) {
				self.rooms = rooms
			}
		}
	}

	public enum UpdateAdults {
		public struct Request {
			public init() {}
		}

		public struct Response: Equatable {
			public let adults: Int

			public init(adults: Int) {
				self.adults = adults
			}
		}

		public struct ViewModel {
			public let adults: Int

			public init(adults: Int) {
				self.adults = adults
			}
		}
	}

	public enum UpdateChildrenAge {
		public struct Request {
			public init() {}
		}

		public struct Response: Equatable {
			public let childrenAge: [Int?]

			public init(childrenAge: [Int?]) {
				self.childrenAge = childrenAge
			}
		}

		public struct ViewModel {
			public let childrenAge: [AgeInputViewModel]

			public init(childrenAge: [AgeInputViewModel]) {
				self.childrenAge = childrenAge
			}
		}
	}

	public enum AgeSelection {
		public struct Request {
			public let index: Int

			public init(index: Int) {
				self.index = index
			}
		}

		public struct Response: Equatable {
			public let index: Int
			public let availableAges: [Int]
			public let selectedAge: Int?

			public init(index: Int, availableAges: [Int], selectedAge: Int?) {
				self.index = index
				self.availableAges = availableAges
				self.selectedAge = selectedAge
			}
		}

		public struct ViewModel {
			public let index: Int
			public let selectedIndex: Int?
			public let availableAges: [(value: Int, title: String)]

			public init(index: Int, selectedIndex: Int?, availableAges: [(value: Int, title: String)]) {
				self.index = index
				self.selectedIndex = selectedIndex
				self.availableAges = availableAges
			}
		}
	}

	public enum AgeSelected {
		public struct Request {
			public let index: Int
			public let age: Int

			public init(index: Int, age: Int) {
				self.index = index
				self.age = age
			}
		}

		public struct Response: Equatable {
			public let childrenAge: [Int?]

			public init(childrenAge: [Int?]) {
				self.childrenAge = childrenAge
			}
		}

		public struct ViewModel {
			public let childrenAge: [AgeInputViewModel]

			public init(childrenAge: [AgeInputViewModel]) {
				self.childrenAge = childrenAge
			}
		}
	}

	public enum Select {
		public struct Request {
			public init() {}
		}

		public struct Response: Equatable {
			public let rooms: Int
			public let adults: Int
			public let childrenAge: [Int]

			public init(rooms: Int, adults: Int, childrenAge: [Int]) {
				self.rooms = rooms
				self.adults = adults
				self.childrenAge = childrenAge
			}
		}

		public struct ViewModel {
			public let rooms: Int
			public let adults: Int
			public let childrenAge: [Int]

			public init(rooms: Int, adults: Int, childrenAge: [Int]) {
				self.rooms = rooms
				self.adults = adults
				self.childrenAge = childrenAge
			}
		}
	}

	public struct ViewModel: Equatable {
		public let rooms: Int
		public let adults: Int
		public let childrenAge: [Int]

		public init(rooms: Int, adults: Int, childrenAge: [Int]) {
			self.rooms = rooms
			self.adults = adults
			self.childrenAge = childrenAge
		}
	}

	public struct AgeInputViewModel {
		let index: Int
		let title: String
		let selectedAgeTitle: String
	}
}

//
//  RoomGuestsPickerModels.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 20/6/25.
//

import Foundation

public enum RoomGuestsPickerModels {
	public enum LoadLimits {
		public struct Request {}

		public struct Response {
			let limits: RoomGuestsLimits
		}
	}

	public enum UpdateRooms {
		public struct Request {}

		public struct Response {
			let rooms: Int
		}

		public struct ViewModel {
			let rooms: Int
		}
	}

	public enum UpdateAdults {
		public struct Request {}

		public struct Response {
			let adults: Int
		}

		public struct ViewModel {
			let adults: Int
		}
	}

	public enum UpdateChildrenAge {
		public struct Request {}

		public struct Response {
			let childrenAge: [Int]
		}

		public struct ViewModel {
			let childrenAge: [Int]

			var children: Int { childrenAge.count }
		}
	}

	public struct ViewModel {
		let rooms: Int
		let adults: Int
		let childrenAge: [Int]

		var children: Int { childrenAge.count }
	}
}

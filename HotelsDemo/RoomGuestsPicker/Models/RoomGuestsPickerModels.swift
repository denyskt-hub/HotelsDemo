//
//  RoomGuestsPickerModels.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 20/6/25.
//

import Foundation

enum RoomGuestsPickerModels {
	enum LoadLimits {
		struct Request {}

		struct Response {
			let limits: RoomGuestsLimits
		}
	}
}

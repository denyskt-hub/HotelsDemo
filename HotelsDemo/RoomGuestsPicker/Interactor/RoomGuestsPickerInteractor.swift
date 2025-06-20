//
//  RoomGuestsPickerInteractor.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 20/6/25.
//

import Foundation

protocol RoomGuestsPickerBusinessLogic {
	func loadRoomGuestsLimits(request: RoomGuestsPickerModels.LoadLimits.Request)
}

final class RoomGuestsPickerInteractor: RoomGuestsPickerBusinessLogic {
	var presenter: RoomGuestsPickerPresentationLogic?

	func loadRoomGuestsLimits(request: RoomGuestsPickerModels.LoadLimits.Request) {
		let limits = RoomGuestsLimits(maxRooms: 30, maxAdults: 30, maxChildren: 10)
		presenter?.presentLimits(response: RoomGuestsPickerModels.LoadLimits.Response(limits: limits))
	}
}

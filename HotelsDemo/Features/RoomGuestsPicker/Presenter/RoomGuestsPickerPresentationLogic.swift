//
//  RoomGuestsPickerPresentationLogic.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 21/6/25.
//

import Foundation

protocol RoomGuestsPickerPresentationLogic {
	func presentLimits(response: RoomGuestsPickerModels.LoadLimits.Response)
	func presentRoomGuests(response: RoomGuestsPickerModels.Load.Response)

	func presentUpdateRooms(response: RoomGuestsPickerModels.UpdateRooms.Response)
	func presentUpdateAdults(response: RoomGuestsPickerModels.UpdateAdults.Response)
	func presentUpdateChildrenAge(response: RoomGuestsPickerModels.UpdateChildrenAge.Response)

	func presentAgePicker(response: RoomGuestsPickerModels.AgeSelection.Response)
	func presentChildrenAge(response: RoomGuestsPickerModels.AgeSelected.Response)

	func presentSelectedRoomGuests(response: RoomGuestsPickerModels.Select.Response)
}

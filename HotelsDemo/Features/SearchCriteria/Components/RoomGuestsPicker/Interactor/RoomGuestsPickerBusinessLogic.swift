//
//  RoomGuestsPickerBusinessLogic.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 21/6/25.
//

import Foundation

public protocol RoomGuestsPickerBusinessLogic {
	func loadLimits(request: RoomGuestsPickerModels.LoadLimits.Request)
	func load(request: RoomGuestsPickerModels.Load.Request)

	func didDecrementRooms()
	func didIncrementRooms()

	func didDecrementAdults()
	func didIncrementAdults()

	func didDecrementChildrenAge()
	func didIncrementChildrenAge()

	func didRequestAgePicker(request: RoomGuestsPickerModels.AgeSelection.Request)
	func didSelectAge(request: RoomGuestsPickerModels.AgeSelected.Request)

	func selectRoomGuests(request: RoomGuestsPickerModels.Select.Request)
}

//
//  RoomGuestsPickerBusinessLogic.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 21/6/25.
//

import Foundation

public protocol RoomGuestsPickerBusinessLogic {
	func doFetchLimits(request: RoomGuestsPickerModels.FetchLimits.Request)
	func doFetchRoomGuests(request: RoomGuestsPickerModels.FetchRoomGuests.Request)

	func handleDecrementRooms()
	func handleIncrementRooms()

	func handleDecrementAdults()
	func handleIncrementAdults()

	func handleDecrementChildrenAge()
	func handleIncrementChildrenAge()

	func handleAgePicker(request: RoomGuestsPickerModels.AgeSelection.Request)
	func handleAgeSelection(request: RoomGuestsPickerModels.AgeSelected.Request)

	func handleRoomGuestsSelection(request: RoomGuestsPickerModels.Select.Request)
}

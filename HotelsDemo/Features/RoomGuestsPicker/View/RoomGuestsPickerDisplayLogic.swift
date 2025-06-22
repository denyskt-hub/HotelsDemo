//
//  RoomGuestsPickerDisplayLogic.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 21/6/25.
//

import Foundation

public protocol RoomGuestsPickerDisplayLogic: AnyObject {
	func applyLimits(_ limits: RoomGuestsLimits)
	func displayRoomGuests(viewModel: RoomGuestsPickerModels.Load.ViewModel)

	func displayRooms(viewModel: RoomGuestsPickerModels.UpdateRooms.ViewModel)
	func displayAdults(viewModel: RoomGuestsPickerModels.UpdateAdults.ViewModel)
	func displayChildrenAge(viewModel: RoomGuestsPickerModels.UpdateChildrenAge.ViewModel)

	func displayAgePicker(viewModel: RoomGuestsPickerModels.AgeSelection.ViewModel)
	func displayChildrenAge(viewModel: RoomGuestsPickerModels.AgeSelected.ViewModel)

	func displaySelectedRoomGuests(viewModel: RoomGuestsPickerModels.Select.ViewModel)
}

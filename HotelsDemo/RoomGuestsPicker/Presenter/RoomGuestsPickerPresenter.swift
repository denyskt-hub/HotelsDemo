//
//  RoomGuestsPickerPresenter.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 20/6/25.
//

import Foundation

protocol RoomGuestsPickerPresentationLogic {
	func presentLimits(response: RoomGuestsPickerModels.LoadLimits.Response)
	func presentUpdateRooms(response: RoomGuestsPickerModels.UpdateRooms.Response)
	func presentUpdateAdults(response: RoomGuestsPickerModels.UpdateAdults.Response)
}

final class RoomGuestsPickerPresenter: RoomGuestsPickerPresentationLogic {
	weak var viewController: RoomGuestsPickerDisplayLogic?

	func presentLimits(response: RoomGuestsPickerModels.LoadLimits.Response) {
		viewController?.applyLimits(response.limits)
	}

	func presentUpdateRooms(response: RoomGuestsPickerModels.UpdateRooms.Response) {
		let viewModel = RoomGuestsPickerModels.UpdateRooms.ViewModel(rooms: response.rooms)
		viewController?.displayRooms(viewModel: viewModel)
	}

	func presentUpdateAdults(response: RoomGuestsPickerModels.UpdateAdults.Response) {
		let viewModel = RoomGuestsPickerModels.UpdateAdults.ViewModel(adults: response.adults)
		viewController?.displayAdults(viewModel: viewModel)
	}
}

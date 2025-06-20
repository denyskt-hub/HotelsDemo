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
}

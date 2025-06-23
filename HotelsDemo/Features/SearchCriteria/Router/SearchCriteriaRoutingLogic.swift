//
//  SearchCriteriaRoutingLogic.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 21/6/25.
//

import Foundation

protocol SearchCriteriaRoutingLogic {
	func routeToDestinationPicker()
	func routeToDateRangePicker(viewModel: DateRangePickerModels.ViewModel)
	func routeToRoomGuestsPicker(viewModel: RoomGuestsPickerModels.ViewModel)
}

//
//  HotelsSearchCriteriaDisplayLogic.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 21/6/25.
//

import Foundation

public protocol HotelsSearchCriteriaDisplayLogic: AnyObject {
	func displayCriteria(viewModel: HotelsSearchCriteriaModels.Fetch.ViewModel)
	func displayLoadError(viewModel: HotelsSearchCriteriaModels.ErrorViewModel)
	func displayUpdateError(viewModel: HotelsSearchCriteriaModels.ErrorViewModel)
	func displayDates(viewModel: DateRangePickerModels.ViewModel)
	func displayRoomGuests(viewModel: RoomGuestsPickerModels.ViewModel)
	func displaySearch(viewModel: HotelsSearchCriteriaModels.Search.ViewModel)
}

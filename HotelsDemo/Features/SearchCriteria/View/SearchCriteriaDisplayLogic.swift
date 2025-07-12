//
//  SearchCriteriaDisplayLogic.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 21/6/25.
//

import Foundation

public protocol SearchCriteriaDisplayLogic: AnyObject {
	func displayCriteria(viewModel: SearchCriteriaModels.Load.ViewModel)
	func displayLoadError(viewModel: SearchCriteriaModels.ErrorViewModel)
	func displayUpdateError(viewModel: SearchCriteriaModels.ErrorViewModel)
	func displayDates(viewModel: DateRangePickerModels.ViewModel)
	func displayRoomGuests(viewModel: RoomGuestsPickerModels.ViewModel)
	func displaySearch(viewModel: SearchCriteriaModels.Search.ViewModel)
}

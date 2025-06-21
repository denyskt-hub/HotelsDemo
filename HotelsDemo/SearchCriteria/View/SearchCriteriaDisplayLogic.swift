//
//  SearchCriteriaDisplayLogic.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 21/6/25.
//

import Foundation

protocol SearchCriteriaDisplayLogic: AnyObject {
	func displayCriteria(viewModel: SearchCriteriaModels.Load.ViewModel)
	func displayLoadError(viewModel: SearchCriteriaModels.Load.ErrorViewModel)
	func displayUpdateError(viewModel: SearchCriteriaModels.UpdateDestination.ErrorViewModel)
	func displayRoomGuests(viewModel: RoomGuestsPickerModels.ViewModel)
}

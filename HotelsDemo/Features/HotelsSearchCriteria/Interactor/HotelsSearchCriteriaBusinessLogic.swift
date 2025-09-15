//
//  HotelsSearchCriteriaBusinessLogic.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 21/6/25.
//

import Foundation

public protocol HotelsSearchCriteriaBusinessLogic {
	func loadCriteria(request: HotelsSearchCriteriaModels.Load.Request)
	func loadDates(request: HotelsSearchCriteriaModels.LoadDates.Request)
	func loadRoomGuests(request: HotelsSearchCriteriaModels.LoadRoomGuests.Request)

	func handleDestinationSelection(request: HotelsSearchCriteriaModels.DestinationSelection.Request)
	func handleDateRangeSelection(request: HotelsSearchCriteriaModels.DateRangeSelection.Request)
	func handleRoomGuestsSelection(request: HotelsSearchCriteriaModels.RoomGuestsSelection.Request)

	func search(request: HotelsSearchCriteriaModels.Search.Request)
}

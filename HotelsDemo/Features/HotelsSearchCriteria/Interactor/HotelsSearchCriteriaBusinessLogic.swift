//
//  HotelsSearchCriteriaBusinessLogic.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 21/6/25.
//

import Foundation

public protocol HotelsSearchCriteriaBusinessLogic {
	func doFetchCriteria(request: HotelsSearchCriteriaModels.Fetch.Request)
	func doFetchDateRange(request: HotelsSearchCriteriaModels.FetchDates.Request)
	func doFetchRoomGuests(request: HotelsSearchCriteriaModels.FetchRoomGuests.Request)
	func doSearch(request: HotelsSearchCriteriaModels.Search.Request)

	func handleDestinationSelection(request: HotelsSearchCriteriaModels.DestinationSelection.Request)
	func handleDateRangeSelection(request: HotelsSearchCriteriaModels.DateRangeSelection.Request)
	func handleRoomGuestsSelection(request: HotelsSearchCriteriaModels.RoomGuestsSelection.Request)
}

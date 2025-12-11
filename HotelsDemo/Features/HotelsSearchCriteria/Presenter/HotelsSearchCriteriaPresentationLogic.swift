//
//  HotelsSearchCriteriaPresentationLogic.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 21/6/25.
//

import Foundation

@MainActor
public protocol HotelsSearchCriteriaPresentationLogic: Sendable {
	func presentLoadCriteria(response: HotelsSearchCriteriaModels.FetchCriteria.Response)
	func presentLoadError(_ error: Error)

	func presentDates(response: HotelsSearchCriteriaModels.FetchDates.Response)
	func presentRoomGuests(response: HotelsSearchCriteriaModels.FetchRoomGuests.Response)

	func presentUpdateDestination(response: HotelsSearchCriteriaModels.DestinationSelection.Response)
	func presentUpdateDates(response: HotelsSearchCriteriaModels.DateRangeSelection.Response)
	func presentUpdateRoomGuests(response: HotelsSearchCriteriaModels.RoomGuestsSelection.Response)
	func presentUpdateError(_ error: Error)

	func presentSearch(response: HotelsSearchCriteriaModels.Search.Response)
}

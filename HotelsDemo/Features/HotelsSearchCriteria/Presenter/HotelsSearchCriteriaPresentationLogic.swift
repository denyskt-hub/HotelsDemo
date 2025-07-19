//
//  HotelsSearchCriteriaPresentationLogic.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 21/6/25.
//

import Foundation

public protocol HotelsSearchCriteriaPresentationLogic {
	func presentLoadCriteria(response: HotelsSearchCriteriaModels.Load.Response)
	func presentLoadError(_ error: Error)

	func presentDates(response: HotelsSearchCriteriaModels.LoadDates.Response)
	func presentRoomGuests(response: HotelsSearchCriteriaModels.LoadRoomGuests.Response)

	func presentUpdateDestination(response: HotelsSearchCriteriaModels.UpdateDestination.Response)
	func presentUpdateDates(response: HotelsSearchCriteriaModels.UpdateDates.Response)
	func presentUpdateRoomGuests(response: HotelsSearchCriteriaModels.UpdateRoomGuests.Response)
	func presentUpdateError(_ error: Error)

	func presentSearch(response: HotelsSearchCriteriaModels.Search.Response)
}

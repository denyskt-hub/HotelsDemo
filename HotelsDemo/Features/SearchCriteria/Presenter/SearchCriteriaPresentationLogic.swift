//
//  SearchCriteriaPresentationLogic.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 21/6/25.
//

import Foundation

public protocol SearchCriteriaPresentationLogic {
	func presentLoadCriteria(response: SearchCriteriaModels.Load.Response)
	func presentLoadError(_ error: Error)

	func presentDates(response: SearchCriteriaModels.LoadDates.Response)
	func presentRoomGuests(response: SearchCriteriaModels.LoadRoomGuests.Response)

	func presentUpdateDestination(response: SearchCriteriaModels.UpdateDestination.Response)
	func presentCriteria(response: SearchCriteriaModels.UpdateDates.Response)
	func presentCriteria(response: SearchCriteriaModels.UpdateRoomGuests.Response)
	func presentUpdateError(_ error: Error)
}

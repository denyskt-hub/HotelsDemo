//
//  SearchCriteriaPresentationLogic.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 21/6/25.
//

import Foundation

protocol SearchCriteriaPresentationLogic {
	func presentCriteria(response: SearchCriteriaModels.Load.Response)
	func presentLoadError(_ error: Error)

	func presentRoomGuests(response: SearchCriteriaModels.LoadRoomGuests.Response)
	func presentDates(response: SearchCriteriaModels.LoadDates.Response)

	func presentCriteria(response: SearchCriteriaModels.UpdateDestination.Response)
	func presentCriteria(response: SearchCriteriaModels.UpdateRoomGuests.Response)
	func presentUpdateError(_ error: Error)
}

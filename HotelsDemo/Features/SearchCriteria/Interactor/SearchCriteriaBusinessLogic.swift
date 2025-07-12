//
//  SearchCriteriaBusinessLogic.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 21/6/25.
//

import Foundation

public protocol SearchCriteriaBusinessLogic {
	func loadCriteria(request: SearchCriteriaModels.Load.Request)
	func loadDates(request: SearchCriteriaModels.LoadDates.Request)
	func loadRoomGuests(request: SearchCriteriaModels.LoadRoomGuests.Request)

	func updateDestination(request: SearchCriteriaModels.UpdateDestination.Request)
	func updateDates(request: SearchCriteriaModels.UpdateDates.Request)
	func updateRoomGuests(request: SearchCriteriaModels.UpdateRoomGuests.Request)

	func search(request: SearchCriteriaModels.Search.Request)
}

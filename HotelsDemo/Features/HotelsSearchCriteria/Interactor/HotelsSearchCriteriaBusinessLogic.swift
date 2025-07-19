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

	func updateDestination(request: HotelsSearchCriteriaModels.UpdateDestination.Request)
	func updateDates(request: HotelsSearchCriteriaModels.UpdateDates.Request)
	func updateRoomGuests(request: HotelsSearchCriteriaModels.UpdateRoomGuests.Request)

	func search(request: HotelsSearchCriteriaModels.Search.Request)
}

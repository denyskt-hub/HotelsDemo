//
//  SearchCriteriaBusinessLogic.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 21/6/25.
//

import Foundation

protocol SearchCriteriaBusinessLogic {
	func loadCriteria(request: SearchCriteriaModels.Load.Request)
	func loadRoomGuests(request: SearchCriteriaModels.LoadRoomGuests.Request)
	func loadDates(request: SearchCriteriaModels.LoadDates.Request)
	func updateDestination(request: SearchCriteriaModels.UpdateDestination.Request)
	func updateRoomGuests(request: SearchCriteriaModels.UpdateRoomGuests.Request)
}

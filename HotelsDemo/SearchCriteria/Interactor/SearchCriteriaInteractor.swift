//
//  SearchCriteriaInteractor.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 19/6/25.
//

import Foundation

protocol SearchCriteriaBusinessLogic {
	func loadCriteria(request: SearchCriteriaModels.Load.Request)
	func updateDestination(request: SearchCriteriaModels.UpdateDestination.Request)
}

final class SearchCriteriaInteractor: SearchCriteriaBusinessLogic {
	var presenter: SearchCriteriaPresentationLogic?

	func loadCriteria(request: SearchCriteriaModels.Load.Request) {
		presenter?.presentCriteria(response: SearchCriteriaModels.Load.Response(criteria: .default))
	}

	func updateDestination(request: SearchCriteriaModels.UpdateDestination.Request) {
		// save destination
		var criteria = SearchCriteria.default
		criteria.destination = request.destination
		presenter?.presentCriteria(response: SearchCriteriaModels.Load.Response(criteria: criteria))
	}
}

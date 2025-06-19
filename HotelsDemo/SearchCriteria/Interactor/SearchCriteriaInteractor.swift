//
//  SearchCriteriaInteractor.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 19/6/25.
//

import Foundation

protocol SearchCriteriaBusinessLogic {
	func loadCriteria()
	func updateDestination(request: SearchCriteriaModels.UpdateDestination.Request)
}

final class SearchCriteriaInteractor: SearchCriteriaBusinessLogic {
	var presenter: SearchCriteriaPresentationLogic?

	func loadCriteria() {
		presenter?.presentCriteria(response: SearchCriteriaModels.Response(criteria: nil))
	}

	func updateDestination(request: SearchCriteriaModels.UpdateDestination.Request) {
		// save destination
		presenter?.presentCriteria(response: SearchCriteriaModels.Response(criteria: nil))
	}
}

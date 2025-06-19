//
//  SearchCriteriaInteractor.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 19/6/25.
//

import Foundation

protocol SearchCriteriaBusinessLogic {
	func loadCriteria()
}

final class SearchCriteriaInteractor: SearchCriteriaBusinessLogic {
	var presenter: SearchCriteriaPresentationLogic?

	func loadCriteria() {

	}
}

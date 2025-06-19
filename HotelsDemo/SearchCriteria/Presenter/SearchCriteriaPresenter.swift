//
//  SearchCriteriaPresenter.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 19/6/25.
//

import Foundation

protocol SearchCriteriaPresentationLogic {
	func presentCriteria(response: SearchCriteriaModels.Response)
}

final class SearchCriteriaPresenter: SearchCriteriaPresentationLogic {
	weak var viewController: SearchCriteriaDisplayLogic?

	func presentCriteria(response: SearchCriteriaModels.Response) {
		let viewModel = SearchCriteriaModels.ViewModel(
			destination: "",
			dateRange: "",
			roomGuests: ""
		)
		viewController?.displayCriteria(viewModel: viewModel)
	}
}

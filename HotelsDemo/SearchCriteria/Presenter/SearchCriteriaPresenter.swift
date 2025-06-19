//
//  SearchCriteriaPresenter.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 19/6/25.
//

import Foundation

protocol SearchCriteriaPresentationLogic {
	func presentCriteria(response: SearchCriteriaModels.Load.Response)
}

final class SearchCriteriaPresenter: SearchCriteriaPresentationLogic {
	weak var viewController: SearchCriteriaDisplayLogic?

	func presentCriteria(response: SearchCriteriaModels.Load.Response) {
		let viewModel = SearchCriteriaModels.Load.ViewModel(
			destination: response.criteria.destination?.label,
			dateRange: "\(response.criteria.checkInDate) - \(response.criteria.checkOutDate)",
			roomGuests: "\(response.criteria.roomsQuantity) room(s) for \(response.criteria.adults) adult(s)"
		)
		viewController?.displayCriteria(viewModel: viewModel)
	}
}

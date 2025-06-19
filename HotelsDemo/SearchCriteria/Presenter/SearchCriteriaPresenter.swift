//
//  SearchCriteriaPresenter.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 19/6/25.
//

import Foundation

protocol SearchCriteriaPresentationLogic {
	func presentCriteria(response: SearchCriteriaModels.Load.Response)
	func presentCriteria(response: SearchCriteriaModels.UpdateDestination.Response)
}

final class SearchCriteriaPresenter: SearchCriteriaPresentationLogic {
	weak var viewController: SearchCriteriaDisplayLogic?

	func presentCriteria(response: SearchCriteriaModels.Load.Response) {
		presentCriteria(response.criteria)
	}

	func presentCriteria(response: SearchCriteriaModels.UpdateDestination.Response) {
		presentCriteria(response.criteria)
	}

	private func presentCriteria(_ criteria: SearchCriteria) {
		let dareRange = "\(criteria.checkInDate) - \(criteria.checkOutDate)"

		let adults = "\(criteria.adults) adult(s)"
		let children = "\(criteria.childrenAge?.components(separatedBy: ",").count ?? 0) child(ren)"
		let rooms = "\(criteria.roomsQuantity) room(s)"
		let roomGuests = "\(rooms) for \(adults), \(children)"

		let viewModel = SearchCriteriaModels.Load.ViewModel(
			destination: criteria.destination?.label,
			dateRange: dareRange,
			roomGuests: roomGuests
		)

		viewController?.displayCriteria(viewModel: viewModel)
	}
}

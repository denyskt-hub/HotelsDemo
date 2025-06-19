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
		let dareRange = "\(response.criteria.checkInDate) - \(response.criteria.checkOutDate)"

		let adults = "\(response.criteria.adults) adult(s)"
		let children = "\(response.criteria.childrenAge?.components(separatedBy: ",").count ?? 0) child(ren)"
		let rooms = "\(response.criteria.roomsQuantity) room(s)"
		let roomGuests = "\(rooms) for \(adults), \(children)"

		let viewModel = SearchCriteriaModels.Load.ViewModel(
			destination: response.criteria.destination?.label,
			dateRange: dareRange,
			roomGuests: roomGuests
		)

		viewController?.displayCriteria(viewModel: viewModel)
	}
}

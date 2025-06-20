//
//  SearchCriteriaPresenter.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 19/6/25.
//

import Foundation

protocol SearchCriteriaPresentationLogic {
	func presentCriteria(response: SearchCriteriaModels.Load.Response)
	func presentLoadError(_ error: Error)

	func presentRoomGuests(response: SearchCriteriaModels.LoadRoomGuests.Response)

	func presentCriteria(response: SearchCriteriaModels.UpdateDestination.Response)
	func presentUpdateError(_ error: Error)
}

final class SearchCriteriaPresenter: SearchCriteriaPresentationLogic {
	weak var viewController: SearchCriteriaDisplayLogic?

	func presentCriteria(response: SearchCriteriaModels.Load.Response) {
		presentCriteria(response.criteria)
	}

	func presentLoadError(_ error: Error) {
		let viewModel = SearchCriteriaModels.Load.ErrorViewModel(message: error.localizedDescription)
		viewController?.displayLoadError(viewModel: viewModel)
	}

	func presentRoomGuests(response: SearchCriteriaModels.LoadRoomGuests.Response) {
		presentRoomGuests(response.roomGuests)
	}

	func presentCriteria(response: SearchCriteriaModels.UpdateDestination.Response) {
		presentCriteria(response.criteria)
	}

	func presentUpdateError(_ error: Error) {
		let viewModel = SearchCriteriaModels.UpdateDestination.ErrorViewModel(message: error.localizedDescription)
		viewController?.displayUpdateError(viewModel: viewModel)
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

	private func presentRoomGuests(_ roomGuests: RoomGuests) {
		let viewModel = RoomGuestsPickerModels.ViewModel(
			rooms: roomGuests.rooms,
			adults: roomGuests.adults,
			children: roomGuests.children
		)
		viewController?.displayRoomGuests(viewModel: viewModel)
	}
}

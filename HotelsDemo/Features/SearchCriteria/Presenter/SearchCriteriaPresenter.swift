//
//  SearchCriteriaPresenter.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 19/6/25.
//

import Foundation

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

	func presentDates(response: SearchCriteriaModels.LoadDates.Response) {
		presentDates(response.checkInDate, response.checkOutDate)
	}

	func presentCriteria(response: SearchCriteriaModels.UpdateDestination.Response) {
		presentCriteria(response.criteria)
	}

	func presentCriteria(response: SearchCriteriaModels.UpdateDates.Response) {
		presentCriteria(response.criteria)
	}

	func presentCriteria(response: SearchCriteriaModels.UpdateRoomGuests.Response) {
		presentCriteria(response.criteria)
	}

	func presentUpdateError(_ error: Error) {
		let viewModel = SearchCriteriaModels.UpdateDestination.ErrorViewModel(message: error.localizedDescription)
		viewController?.displayUpdateError(viewModel: viewModel)
	}

	private func presentCriteria(_ criteria: SearchCriteria) {
		let dareRange = "\(criteria.checkInDate) - \(criteria.checkOutDate)"

		let adults = "\(criteria.adults) adult(s)"
		let children = "\(criteria.childrenAge.count) child(ren)"
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
			childrenAge: roomGuests.childrenAge
		)
		viewController?.displayRoomGuests(viewModel: viewModel)
	}

	private func presentDates(_ checkInDate: Date, _ checkOutDate: Date) {
		let viewModel = DateRangePickerModels.ViewModel(
			startDate: checkInDate,
			endDate: checkOutDate
		)
		viewController?.displayDates(viewModel: viewModel)
	}
}

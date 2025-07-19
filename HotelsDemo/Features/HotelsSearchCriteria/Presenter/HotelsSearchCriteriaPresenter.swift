//
//  HotelsSearchCriteriaPresenter.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 19/6/25.
//

import Foundation

public final class HotelsSearchCriteriaPresenter: HotelsSearchCriteriaPresentationLogic {
	private let dateFormatter: DateFormatter

	public weak var viewController: HotelsSearchCriteriaDisplayLogic?

	public init(calendar: Calendar) {
		self.dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "d MMM"
		dateFormatter.calendar = calendar
		dateFormatter.timeZone = calendar.timeZone
	}

	public func presentLoadCriteria(response: HotelsSearchCriteriaModels.Load.Response) {
		presentCriteria(response.criteria)
	}

	public func presentLoadError(_ error: Error) {
		let viewModel = HotelsSearchCriteriaModels.ErrorViewModel(message: error.localizedDescription)
		viewController?.displayLoadError(viewModel: viewModel)
	}

	public func presentRoomGuests(response: HotelsSearchCriteriaModels.LoadRoomGuests.Response) {
		presentRoomGuests(response.roomGuests)
	}

	public func presentDates(response: HotelsSearchCriteriaModels.LoadDates.Response) {
		presentDates(response.checkInDate, response.checkOutDate)
	}

	public func presentUpdateDestination(response: HotelsSearchCriteriaModels.UpdateDestination.Response) {
		presentCriteria(response.criteria)
	}

	public func presentUpdateDates(response: HotelsSearchCriteriaModels.UpdateDates.Response) {
		presentCriteria(response.criteria)
	}

	public func presentUpdateRoomGuests(response: HotelsSearchCriteriaModels.UpdateRoomGuests.Response) {
		presentCriteria(response.criteria)
	}

	public func presentUpdateError(_ error: Error) {
		let viewModel = HotelsSearchCriteriaModels.ErrorViewModel(message: error.localizedDescription)
		viewController?.displayUpdateError(viewModel: viewModel)
	}

	public func presentSearch(response: HotelsSearchCriteriaModels.Search.Response) {
		let viewModel = HotelsSearchCriteriaModels.Search.ViewModel(criteria: response.criteria)
		viewController?.displaySearch(viewModel: viewModel)
	}

	private func presentCriteria(_ criteria: HotelsSearchCriteria) {
		let checkIn = dateFormatter.string(from: criteria.checkInDate)
		let checkOut = dateFormatter.string(from: criteria.checkOutDate)
		let dareRange = "\(checkIn) – \(checkOut)"

		let roomGuests = formatRoomGuests(
			rooms: criteria.roomsQuantity,
			adults: criteria.adults,
			children: criteria.childrenAge.count
		)

		let viewModel = HotelsSearchCriteriaModels.Load.ViewModel(
			destination: criteria.destination?.label,
			dateRange: dareRange,
			roomGuests: roomGuests
		)

		viewController?.displayCriteria(viewModel: viewModel)
	}

	private func formatRoomGuests(rooms: Int, adults: Int, children: Int) -> String {
		let roomPart = "\(rooms) room" + (rooms == 1 ? "" : "s")
		let adultPart = "\(adults) adult" + (adults == 1 ? "" : "s")
		let childPart = children > 0 ? ", \(children) child" + (children == 1 ? "" : "ren") : ""
		return "\(roomPart) for \(adultPart)\(childPart)"
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

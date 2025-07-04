//
//  SearchCriteriaRouter.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 19/6/25.
//

import UIKit

public final class SearchCriteriaRouter: SearchCriteriaRoutingLogic {
	private let calendar: Calendar
	private let destinationPickerFactory: DestinationPickerFactory
	private let dateRangePickerFactory: DateRangePickerFactory
	private let roomGuestsPickerFactory: RoomGuestsPickerFactory

	public weak var viewController: UIViewController?

	public init(
		calendar: Calendar,
		destinationPickerFactory: DestinationPickerFactory,
		dateRangePickerFactory: DateRangePickerFactory,
		roomGuestsPickerFactory: RoomGuestsPickerFactory
	) {
		self.calendar = calendar
		self.destinationPickerFactory = destinationPickerFactory
		self.dateRangePickerFactory = dateRangePickerFactory
		self.roomGuestsPickerFactory = roomGuestsPickerFactory
	}

	public func routeToDestinationPicker() {
		let destinationVC = destinationPickerFactory.makeDestinationPicker(delegate: self)
		viewController?.present(destinationVC, animated: true)
	}

	public func routeToDateRangePicker(viewModel: DateRangePickerModels.ViewModel) {
		let dateRangeVC = dateRangePickerFactory.makeDateRangePicker(
			delegate: self,
			selectedStartDate: viewModel.startDate,
			selectedEndDate: viewModel.endDate,
			calendar: calendar
		)
		viewController?.present(dateRangeVC, animated: true)
	}

	public func routeToRoomGuestsPicker(viewModel: RoomGuestsPickerModels.ViewModel) {
		let roomGuestsVC = roomGuestsPickerFactory.makeRoomGuestsPicker(
			delegate: self,
			rooms: viewModel.rooms,
			adults: viewModel.adults,
			childrenAge: viewModel.childrenAge
		)
		viewController?.present(roomGuestsVC, animated: true)
	}
}

extension SearchCriteriaRouter: DestinationPickerDelegate {
	public func didSelectDestination(_ destination: Destination) {
		guard let source = self.viewController as? SearchCriteriaViewController else { return }

		source.interactor?.updateDestination(
			request: SearchCriteriaModels.UpdateDestination.Request(destination: destination)
		)
	}
}

extension SearchCriteriaRouter: DataRangePickerDelegate {
	public func didSelectDateRange(startDate: Date, endDate: Date) {
		guard let source = self.viewController as? SearchCriteriaViewController else { return }

		source.interactor?.updateDates(
			request: SearchCriteriaModels.UpdateDates.Request(checkInDate: startDate, checkOutDate: endDate)
		)
	}
}

extension SearchCriteriaRouter: RoomGuestsPickerDelegate {
	public func didSelectRoomGuests(rooms: Int, adults: Int, childrenAges: [Int]) {
		guard let source = self.viewController as? SearchCriteriaViewController else { return }

		source.interactor?.updateRoomGuests(
			request: SearchCriteriaModels.UpdateRoomGuests.Request(
				rooms: rooms,
				adults: adults,
				childrenAge: childrenAges
			)
		)
	}
}

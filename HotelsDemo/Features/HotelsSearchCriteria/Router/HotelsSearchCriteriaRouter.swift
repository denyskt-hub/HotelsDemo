//
//  HotelsSearchCriteriaRouter.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 19/6/25.
//

import UIKit

public final class HotelsSearchCriteriaRouter: HotelsSearchCriteriaRoutingLogic {
	private let calendar: Calendar
	private let destinationPickerFactory: DestinationPickerFactory
	private let dateRangePickerFactory: DateRangePickerFactory
	private let roomGuestsPickerFactory: RoomGuestsPickerFactory

	public weak var viewController: HotelsSearchCriteriaScene?

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
		let destinationVC = destinationPickerFactory.makeDestinationPicker(delegate: viewController)

		if let sheet = destinationVC.sheetPresentationController {
			sheet.detents = [.large()]
			sheet.prefersGrabberVisible = true
		}

		viewController?.present(destinationVC, animated: true)
	}

	public func routeToDateRangePicker(viewModel: DateRangePickerModels.ViewModel) {
		let dateRangeVC = dateRangePickerFactory.makeDateRangePicker(
			delegate: viewController,
			selectedStartDate: viewModel.startDate,
			selectedEndDate: viewModel.endDate,
			calendar: calendar
		)

		if let sheet = dateRangeVC.sheetPresentationController {
			sheet.detents = [.large()]
			sheet.prefersGrabberVisible = true
		}

		viewController?.present(dateRangeVC, animated: true)
	}

	public func routeToRoomGuestsPicker(viewModel: RoomGuestsPickerModels.ViewModel) {
		let roomGuestsVC = roomGuestsPickerFactory.makeRoomGuestsPicker(
			delegate: viewController,
			rooms: viewModel.rooms,
			adults: viewModel.adults,
			childrenAge: viewModel.childrenAge
		)

		if let sheet = roomGuestsVC.sheetPresentationController {
			sheet.detents = [.medium(), .large()]
			sheet.prefersGrabberVisible = true
		}

		viewController?.present(roomGuestsVC, animated: true)
	}
}

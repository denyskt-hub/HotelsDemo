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
	private let scene: HotelsSearchCriteriaScene

	public init(
		calendar: Calendar,
		destinationPickerFactory: DestinationPickerFactory,
		dateRangePickerFactory: DateRangePickerFactory,
		roomGuestsPickerFactory: RoomGuestsPickerFactory,
		scene: HotelsSearchCriteriaScene
	) {
		self.calendar = calendar
		self.destinationPickerFactory = destinationPickerFactory
		self.dateRangePickerFactory = dateRangePickerFactory
		self.roomGuestsPickerFactory = roomGuestsPickerFactory
		self.scene = scene
	}

	public func routeToDestinationPicker() {
		let destinationVC = destinationPickerFactory.makeDestinationPicker(delegate: scene)

		if let sheet = destinationVC.sheetPresentationController {
			sheet.detents = [.large()]
			sheet.prefersGrabberVisible = true
		}

		scene.present(destinationVC)
	}

	public func routeToDateRangePicker(viewModel: DateRangePickerModels.ViewModel) {
		let dateRangeVC = dateRangePickerFactory.makeDateRangePicker(
			delegate: scene,
			selectedStartDate: viewModel.startDate,
			selectedEndDate: viewModel.endDate,
			calendar: calendar
		)

		if let sheet = dateRangeVC.sheetPresentationController {
			sheet.detents = [.large()]
			sheet.prefersGrabberVisible = true
		}

		scene.present(dateRangeVC)
	}

	public func routeToRoomGuestsPicker(viewModel: RoomGuestsPickerModels.ViewModel) {
		let roomGuestsVC = roomGuestsPickerFactory.makeRoomGuestsPicker(
			delegate: scene,
			rooms: viewModel.rooms,
			adults: viewModel.adults,
			childrenAge: viewModel.childrenAge
		)

		if let sheet = roomGuestsVC.sheetPresentationController {
			sheet.detents = [.medium(), .large()]
			sheet.prefersGrabberVisible = true
		}

		scene.present(roomGuestsVC)
	}
}

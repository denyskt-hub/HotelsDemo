//
//  SearchCriteriaViewController.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 19/6/25.
//

import UIKit

public final class SearchCriteriaViewController: NiblessViewController, SearchCriteriaDisplayLogic {
	public var interactor: SearchCriteriaBusinessLogic?
	public var router: SearchCriteriaRoutingLogic?

	private let rootView = SearchCriteriaRootView()

	public var destinationControl: IconTitleControl { rootView.destinationControl }
	public var datesControl: IconTitleControl { rootView.datesControl }
	public var roomGuestsControl: IconTitleControl { rootView.roomGuestsControl }

	public override func loadView() {
		view = rootView
	}

	public override func viewDidLoad() {
		super.viewDidLoad()

		setupDestionationButton()
		setupDatesButton()
		setupRoomGuestsButton()

		interactor?.loadCriteria(request: SearchCriteriaModels.Load.Request())
	}

	private func setupDestionationButton() {
		destinationControl.addTarget(self, action: #selector(destinationTapHandler), for: .touchUpInside)
	}

	private func setupDatesButton() {
		datesControl.addTarget(self, action: #selector(datesTapHandler), for: .touchUpInside)
	}

	private func setupRoomGuestsButton() {
		roomGuestsControl.addTarget(self, action: #selector(roomGuestsTapHandler), for: .touchUpInside)
	}

	@objc private func destinationTapHandler() {
		router?.routeToDestinationPicker()
	}

	@objc private func datesTapHandler() {
		interactor?.loadDates(request: SearchCriteriaModels.LoadDates.Request())
	}

	@objc private func roomGuestsTapHandler() {
		interactor?.loadRoomGuests(request: SearchCriteriaModels.LoadRoomGuests.Request())
	}

	public func displayCriteria(viewModel: SearchCriteriaModels.Load.ViewModel) {
		rootView.destinationControl.setTitle(viewModel.destination)
		rootView.datesControl.setTitle(viewModel.dateRange)
		rootView.roomGuestsControl.setTitle(viewModel.roomGuests)
	}

	public func displayLoadError(viewModel: SearchCriteriaModels.ErrorViewModel) {
		displayError(message: viewModel.message)
	}

	public func displayUpdateError(viewModel: SearchCriteriaModels.ErrorViewModel) {
		displayError(message: viewModel.message)
	}

	public func displayDates(viewModel: DateRangePickerModels.ViewModel) {
		router?.routeToDateRangePicker(viewModel: viewModel)
	}

	public func displayRoomGuests(viewModel: RoomGuestsPickerModels.ViewModel) {
		router?.routeToRoomGuestsPicker(viewModel: viewModel)
	}

	private func displayError(message: String) {
		let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "OK", style: .default))
		present(alert, animated: true)
	}
}

extension SearchCriteriaViewController: SearchCriteriaScene {
	public func didSelectDestination(_ destination: Destination) {
		interactor?.updateDestination(
			request: SearchCriteriaModels.UpdateDestination.Request(destination: destination)
		)
	}

	public func didSelectDateRange(startDate: Date, endDate: Date) {
		interactor?.updateDates(
			request: SearchCriteriaModels.UpdateDates.Request(checkInDate: startDate, checkOutDate: endDate)
		)
	}

	public func didSelectRoomGuests(rooms: Int, adults: Int, childrenAges: [Int]) {
		interactor?.updateRoomGuests(
			request: SearchCriteriaModels.UpdateRoomGuests.Request(
				rooms: rooms,
				adults: adults,
				childrenAge: childrenAges
			)
		)
	}
}

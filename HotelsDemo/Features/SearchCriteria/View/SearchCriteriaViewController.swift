//
//  SearchCriteriaViewController.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 19/6/25.
//

import UIKit

public final class SearchCriteriaViewController: NiblessViewController, SearchCriteriaDisplayLogic {
	public var interactor: SearchCriteriaBusinessLogic?
	public var router: SearchCriteriaRouter?

	private let rootView = SearchCriteriaRootView()

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
		rootView.destinationButton.addTarget(self, action: #selector(destinationButtonHandler), for: .touchUpInside)
	}

	private func setupDatesButton() {
		rootView.datesButton.addTarget(self, action: #selector(datesButtonHandler), for: .touchUpInside)
	}

	private func setupRoomGuestsButton() {
		rootView.roomGuestsButton.addTarget(self, action: #selector(roomGuestsButtonHandler), for: .touchUpInside)
	}

	@objc private func destinationButtonHandler() {
		router?.routeToDestinationPicker()
	}

	@objc private func datesButtonHandler() {
		interactor?.loadDates(request: SearchCriteriaModels.LoadDates.Request())
	}

	@objc private func roomGuestsButtonHandler() {
		interactor?.loadRoomGuests(request: SearchCriteriaModels.LoadRoomGuests.Request())
	}

	public func displayCriteria(viewModel: SearchCriteriaModels.Load.ViewModel) {
		rootView.destinationButton.setTitle(viewModel.destination, for: .normal)
		rootView.datesButton.setTitle(viewModel.dateRange, for: .normal)
		rootView.roomGuestsButton.setTitle(viewModel.roomGuests, for: .normal)
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

	public func displayError(title: String = "Error", message: String) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
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

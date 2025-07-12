//
//  SearchCriteriaViewController.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 19/6/25.
//

import UIKit

public protocol SearchCriteriaDelegate: AnyObject {
	func didRequestSearch(with searchCriteria: SearchCriteria)
}

public final class SearchCriteriaViewController: NiblessViewController, SearchCriteriaDisplayLogic {
	private let rootView = SearchCriteriaRootView()

	public var interactor: SearchCriteriaBusinessLogic?
	public var router: SearchCriteriaRoutingLogic?
	public var delegate: SearchCriteriaDelegate?

	public var destinationControl: IconTitleControl { rootView.destinationControl }
	public var datesControl: IconTitleControl { rootView.datesControl }
	public var roomGuestsControl: IconTitleControl { rootView.roomGuestsControl }
	public var searchButton: UIButton { rootView.searchButton }

	public override func loadView() {
		view = rootView
	}

	public override func viewDidLoad() {
		super.viewDidLoad()

		setupDestionationControl()
		setupDatesControl()
		setupRoomGuestsControl()
		setupSearchButton()

		interactor?.loadCriteria(request: SearchCriteriaModels.Load.Request())
	}

	private func setupDestionationControl() {
		destinationControl.addTarget(self, action: #selector(destinationTapHandler), for: .touchUpInside)
	}

	private func setupDatesControl() {
		datesControl.addTarget(self, action: #selector(datesTapHandler), for: .touchUpInside)
	}

	private func setupRoomGuestsControl() {
		roomGuestsControl.addTarget(self, action: #selector(roomGuestsTapHandler), for: .touchUpInside)
	}

	private func setupSearchButton() {
		searchButton.addTarget(self, action: #selector(searchTapHandler), for: .touchUpInside)
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

	@objc private func searchTapHandler() {
		interactor?.search(request: SearchCriteriaModels.Search.Request())
	}

	public func displayCriteria(viewModel: SearchCriteriaModels.Load.ViewModel) {
		destinationControl.setTitle(viewModel.destination)
		datesControl.setTitle(viewModel.dateRange)
		roomGuestsControl.setTitle(viewModel.roomGuests)
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

	public func displaySearch(viewModel: SearchCriteriaModels.Search.ViewModel) {
		delegate?.didRequestSearch(with: viewModel.criteria)
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

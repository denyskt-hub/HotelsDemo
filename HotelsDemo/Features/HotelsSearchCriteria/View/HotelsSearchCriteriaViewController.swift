//
//  HotelsSearchCriteriaViewController.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 19/6/25.
//

import UIKit

public protocol HotelsSearchCriteriaDelegate: AnyObject {
	func didRequestSearch(with searchCriteria: HotelsSearchCriteria)
}

public final class HotelsSearchCriteriaViewController: NiblessViewController, HotelsSearchCriteriaDisplayLogic {
	private let delegate: HotelsSearchCriteriaDelegate
	private let rootView = HotelsSearchCriteriaRootView()

	public var interactor: HotelsSearchCriteriaBusinessLogic?
	public var router: HotelsSearchCriteriaRoutingLogic?

	public var destinationControl: IconTitleControl { rootView.destinationControl }
	public var datesControl: IconTitleControl { rootView.datesControl }
	public var roomGuestsControl: IconTitleControl { rootView.roomGuestsControl }
	public var searchButton: UIButton { rootView.searchButton }

	public init(delegate: HotelsSearchCriteriaDelegate) {
		self.delegate = delegate
		super.init()
	}

	public override func loadView() {
		view = rootView
	}

	public override func viewDidLoad() {
		super.viewDidLoad()

		setupDestinationControl()
		setupDatesControl()
		setupRoomGuestsControl()
		setupSearchButton()

		interactor?.doFetchCriteria(request: HotelsSearchCriteriaModels.FetchCriteria.Request())
	}

	private func setupDestinationControl() {
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
		interactor?.doFetchDateRange(request: HotelsSearchCriteriaModels.FetchDates.Request())
	}

	@objc private func roomGuestsTapHandler() {
		interactor?.doFetchRoomGuests(request: HotelsSearchCriteriaModels.FetchRoomGuests.Request())
	}

	@objc private func searchTapHandler() {
		interactor?.doSearch(request: HotelsSearchCriteriaModels.Search.Request())
	}

	public func displayCriteria(viewModel: HotelsSearchCriteriaModels.FetchCriteria.ViewModel) {
		destinationControl.setTitle(viewModel.destination)
		datesControl.setTitle(viewModel.dateRange)
		roomGuestsControl.setTitle(viewModel.roomGuests)
		searchButton.isEnabled = viewModel.isSearchEnabled
	}

	public func displayLoadError(viewModel: HotelsSearchCriteriaModels.ErrorViewModel) {
		displayErrorMessage(viewModel.message)
	}

	public func displayUpdateError(viewModel: HotelsSearchCriteriaModels.ErrorViewModel) {
		displayErrorMessage(viewModel.message)
	}

	public func displayDates(viewModel: DateRangePickerModels.ViewModel) {
		router?.routeToDateRangePicker(viewModel: viewModel)
	}

	public func displayRoomGuests(viewModel: RoomGuestsPickerModels.ViewModel) {
		router?.routeToRoomGuestsPicker(viewModel: viewModel)
	}

	public func displaySearch(viewModel: HotelsSearchCriteriaModels.Search.ViewModel) {
		delegate.didRequestSearch(with: viewModel.criteria)
	}
}

// MARK: - HotelsSearchCriteriaScene

extension HotelsSearchCriteriaViewController: HotelsSearchCriteriaScene {
	public func didSelectDestination(_ destination: Destination) {
		interactor?.handleDestinationSelection(
			request: .init(destination: destination)
		)
	}

	public func didSelectDateRange(startDate: Date, endDate: Date) {
		interactor?.handleDateRangeSelection(
			request: .init(
				checkInDate: startDate,
				checkOutDate: endDate
			)
		)
	}

	public func didSelectRoomGuests(rooms: Int, adults: Int, childrenAges: [Int]) {
		interactor?.handleRoomGuestsSelection(
			request: .init(
				rooms: rooms,
				adults: adults,
				childrenAge: childrenAges
			)
		)
	}
}

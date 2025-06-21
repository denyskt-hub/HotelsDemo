//
//  SearchCriteriaViewController.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 19/6/25.
//

import UIKit

final class SearchCriteriaViewController: NiblessViewController, SearchCriteriaDisplayLogic {
	var interactor: SearchCriteriaBusinessLogic?
	var router: SearchCriteriaRouter?

	private let rootView = SearchCriteriaRootView()

	public override func loadView() {
		view = rootView
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		setupDestionationButton()
		setupRoomGuestsButton()

		interactor?.loadCriteria(request: SearchCriteriaModels.Load.Request())
	}

	private func setupDestionationButton() {
		rootView.destinationButton.addTarget(self, action: #selector(destinationButtonHandler), for: .touchUpInside)
	}

	private func setupRoomGuestsButton() {
		rootView.roomGuestsButton.addTarget(self, action: #selector(roomGuestsButtonHandler), for: .touchUpInside)
	}

	@objc private func destinationButtonHandler() {
		router?.routeToDestinationPicker()
	}

	@objc private func roomGuestsButtonHandler() {
		interactor?.loadRoomGuests(request: SearchCriteriaModels.LoadRoomGuests.Request())
	}

	func displayCriteria(viewModel: SearchCriteriaModels.Load.ViewModel) {
		rootView.destinationButton.setTitle(viewModel.destination, for: .normal)
		rootView.datesButton.setTitle(viewModel.dateRange, for: .normal)
		rootView.roomGuestsButton.setTitle(viewModel.roomGuests, for: .normal)
	}

	func displayLoadError(viewModel: SearchCriteriaModels.Load.ErrorViewModel) {
		displayError(message: viewModel.message)
	}

	func displayUpdateError(viewModel: SearchCriteriaModels.UpdateDestination.ErrorViewModel) {
		displayError(message: viewModel.message)
	}

	func displayRoomGuests(viewModel: RoomGuestsPickerModels.ViewModel) {
		router?.routeToRoomGuestsPicker(viewModel: viewModel)
	}

	func displayError(title: String = "Error", message: String) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "OK", style: .default))
		present(alert, animated: true)
	}
}

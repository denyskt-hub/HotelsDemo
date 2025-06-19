//
//  SearchCriteriaViewController.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 19/6/25.
//

import UIKit

protocol SearchCriteriaDisplayLogic: AnyObject {
	func displayCriteria(viewModel: SearchCriteriaModels.Load.ViewModel)
}

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

		interactor?.loadCriteria(request: SearchCriteriaModels.Load.Request())
	}

	private func setupDestionationButton() {
		rootView.destinationButton.addTarget(self, action: #selector(destinationButtonHandler), for: .touchUpInside)
	}

	@objc private func destinationButtonHandler() {
		router?.routeToDestinationPicker()
	}

	func displayCriteria(viewModel: SearchCriteriaModels.Load.ViewModel) {
		rootView.destinationButton.setTitle(viewModel.destination, for: .normal)
		rootView.datesButton.setTitle(viewModel.dateRange, for: .normal)
		rootView.roomGuestsButton.setTitle(viewModel.roomGuests, for: .normal)
	}
}

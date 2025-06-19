//
//  SearchCriteriaViewController.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 19/6/25.
//

import UIKit

protocol SearchCriteriaDisplayLogic: AnyObject {
	func displayCriteria(viewModel: SearchCriteriaModels.ViewModel)
}

final class SearchCriteriaViewController: NiblessViewController, SearchCriteriaDisplayLogic {
	var interactor: SearchCriteriaBusinessLogic?
	var router: SearchCriteriaRouter?

	public override func loadView() {
		view = SearchCriteriaRootView()
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		setupDestionationButton()

		interactor?.loadCriteria()
	}

	private func setupDestionationButton() {
		(view as? SearchCriteriaRootView)?.destinationButton.addTarget(self, action: #selector(destinationButtonHandler), for: .touchUpInside)
	}

	@objc private func destinationButtonHandler() {
		router?.routeToDestinationPicker()
	}

	func displayCriteria(viewModel: SearchCriteriaModels.ViewModel) {
		// Update UI
	}
}

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

	private var rootView: SearchCriteriaRootView {
		guard let view = view as? SearchCriteriaRootView else {
			fatalError("Expected SearchCriteriaRootView as the controller's view")
		}
		return view
	}

	public override func loadView() {
		view = SearchCriteriaRootView()
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		setupDestionationButton()

		interactor?.loadCriteria()
	}

	private func setupDestionationButton() {
		rootView.destinationButton.addTarget(self, action: #selector(destinationButtonHandler), for: .touchUpInside)
	}

	@objc private func destinationButtonHandler() {
		router?.routeToDestinationPicker()
	}

	func displayCriteria(viewModel: SearchCriteriaModels.ViewModel) {
		// Update UI
	}
}

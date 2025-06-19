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

	public override func loadView() {
		view = SearchCriteriaRootView()
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		interactor?.loadCriteria()
	}

	func displayCriteria(viewModel: SearchCriteriaModels.ViewModel) {
		// Update UI
	}
}

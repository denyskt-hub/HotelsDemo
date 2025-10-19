//
//  MainViewController.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 11/7/25.
//

import UIKit

public final class MainViewController: NiblessViewController, MainDisplayLogic {
	private let rootView = MainRootView()
	private var searchCriteriaContainerView: UIView { rootView.searchCriteriaContainerView }

	private let searchCriteriaViewController: UIViewController
	private let interactor: MainBusinessLogic
	private let router: MainRoutingLogic

	public init(
		searchCriteriaViewController: UIViewController,
		interactor: MainBusinessLogic,
		router: MainRoutingLogic
	) {
		self.searchCriteriaViewController = searchCriteriaViewController
		self.interactor = interactor
		self.router = router
		super.init()
	}

	public override func loadView() {
		view = rootView
	}

	public override func viewDidLoad() {
		super.viewDidLoad()

		addChild(searchCriteriaViewController, to: searchCriteriaContainerView)
	}

	public func displaySearch(viewModel: MainModels.Search.ViewModel) {
		router.routeToSearch(viewModel: viewModel)
	}
}

// MARK: - HotelsSearchCriteriaDelegate

extension MainViewController: HotelsSearchCriteriaDelegate {
	public func didRequestSearch(with searchCriteria: HotelsSearchCriteria) {
		interactor.handleSearch(request: MainModels.Search.Request(criteria: searchCriteria))
	}
}

// MARK: - MainScene

extension MainViewController: MainScene {}

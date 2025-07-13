//
//  MainRouter.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 12/7/25.
//

import UIKit

public final class MainRouter: MainRoutingLogic {
	public weak var viewController: UIViewController?

	public func routeToSearch(viewModel: MainModels.Search.ViewModel) {
		let searchVC = SearchViewController()
		let interactor = SearchInteractor(
			criteria: viewModel.criteria,
			worker: HotelsSearchWorker()
		)
		let presenter = SearchPresenter()

		searchVC.interactor = interactor
		interactor.presenter = presenter
		presenter.viewController = searchVC

		viewController?.show(searchVC, sender: nil)
	}
}

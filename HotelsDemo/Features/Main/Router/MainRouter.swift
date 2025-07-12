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
		viewController?.show(searchVC, sender: nil)
	}
}

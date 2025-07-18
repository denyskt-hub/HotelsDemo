//
//  MainRouter.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 12/7/25.
//

import UIKit

public final class MainRouter: MainRoutingLogic {
	private let searchFactory: SearchFactory

	public weak var viewController: UIViewController?

	public init(searchFactory: SearchFactory) {
		self.searchFactory = searchFactory
	}

	public func routeToSearch(viewModel: MainModels.Search.ViewModel) {
		let searchVC = searchFactory.makeSearch(with: viewModel.criteria)

		viewController?.show(searchVC, sender: nil)
	}
}

//
//  MainRouter.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 12/7/25.
//

import UIKit

public final class MainRouter: MainRoutingLogic {
	private let searchFactory: HotelsSearchFactory

	public weak var viewController: UIViewController?

	public init(searchFactory: HotelsSearchFactory) {
		self.searchFactory = searchFactory
	}

	public func routeToSearch(viewModel: MainModels.Search.ViewModel) {
		let searchVC = searchFactory.makeSearch(with: viewModel.criteria)

		viewController?.show(searchVC, sender: nil)
	}
}

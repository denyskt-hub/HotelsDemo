//
//  MainRouter.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 12/7/25.
//

import UIKit

public final class MainRouter: MainRoutingLogic {
	private let searchFactory: HotelsSearchFactory
	private let routable: Routable

	public init(
		searchFactory: HotelsSearchFactory,
		routable: Routable
	) {
		self.searchFactory = searchFactory
		self.routable = routable
	}

	public func routeToSearch(viewModel: MainModels.Search.ViewModel) {
		let searchVC = searchFactory.makeSearch(with: viewModel.criteria)

		routable.show(searchVC)
	}
}

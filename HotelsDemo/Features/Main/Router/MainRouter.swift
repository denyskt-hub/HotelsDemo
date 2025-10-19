//
//  MainRouter.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 12/7/25.
//

import UIKit

public final class MainRouter: MainRoutingLogic {
	private let searchFactory: HotelsSearchFactory
	private let scene: MainScene

	public init(
		searchFactory: HotelsSearchFactory,
		scene: MainScene
	) {
		self.searchFactory = searchFactory
		self.scene = scene
	}

	public func routeToSearch(viewModel: MainModels.Search.ViewModel) {
		let searchVC = searchFactory.makeSearch(with: viewModel.criteria)

		scene.show(searchVC)
	}
}

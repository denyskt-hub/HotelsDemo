//
//  MainPresenter.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 12/7/25.
//

import Foundation

public final class MainPresenter: MainPresentationLogic {
	private let viewController: MainDisplayLogic

	public init(viewController: MainDisplayLogic) {
		self.viewController = viewController
	}

	public func presentSearch(response: MainModels.Search.Response) {
		viewController.displaySearch(viewModel: .init(criteria: response.criteria))
	}
}

//
//  SearchComposer.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 14/7/25.
//

import UIKit

public protocol SearchFactory {
	func makeSearch(with criteria: SearchCriteria) -> UIViewController
}

public final class SearchComposer: SearchFactory {
	public func makeSearch(with criteria: SearchCriteria) -> UIViewController {
		let viewController = SearchViewController()
		let interactor = SearchInteractor(
			criteria: criteria,
			worker: HotelsSearchWorker()
		)
		let presenter = SearchPresenter()

		viewController.interactor = interactor
		interactor.presenter = presenter
		presenter.viewController = viewController

		return viewController
	}
}


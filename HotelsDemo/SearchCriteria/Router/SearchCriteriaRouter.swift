//
//  SearchCriteriaRouter.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 19/6/25.
//

import UIKit

protocol SearchCriteriaRoutingLogic {
	func routeToDestinationPicker()
}

final class SearchCriteriaRouter: SearchCriteriaRoutingLogic {
	weak var viewController: UIViewController?

	func routeToDestinationPicker() {
		let destinationVC = DestinationPickerViewController()
		let interactor = DestinationPickerInteractor()
		let presenter = DestinationPickerPresenter()

		destinationVC.interactor = interactor
		interactor.presenter = presenter
		presenter.viewController = destinationVC

		viewController?.present(destinationVC, animated: true)
	}
}

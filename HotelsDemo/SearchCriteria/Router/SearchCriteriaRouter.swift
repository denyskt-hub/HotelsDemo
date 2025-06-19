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
		let worker = DestinationSearchWorker(dispatcher: MainQueueDispatcher())
		let interactor = DestinationPickerInteractor(worker: worker)
		let presenter = DestinationPickerPresenter()

		destinationVC.interactor = interactor
		destinationVC.delegate = self
		interactor.presenter = presenter
		presenter.viewController = destinationVC

		viewController?.present(destinationVC, animated: true)
	}
}

extension SearchCriteriaRouter: DestinationPickerDelegate {
	func didSelectDestination(_ destination: Destination) {
		guard let source = self.viewController as? SearchCriteriaViewController else { return }

		source.interactor?.updateDestination(
			request: SearchCriteriaModels.UpdateDestination.Request(destination: destination)
		)
	}
}

//
//  SearchCriteriaRouter.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 19/6/25.
//

import UIKit

protocol SearchCriteriaRoutingLogic {
	func routeToDestinationPicker()
	func routeToRoomGuestsPicker()
}

final class SearchCriteriaRouter: SearchCriteriaRoutingLogic {
	weak var viewController: UIViewController?

	func routeToDestinationPicker() {
		let destinationVC = DestinationPickerViewController()
		let worker = DestinationSearchWorker(
			url: URL(string: "https://booking-com15.p.rapidapi.com/api/v1/hotels/searchDestination")!,
			client: URLSessionHTTPClient(),
			dispatcher: MainQueueDispatcher()
		)
		let interactor = DestinationPickerInteractor(worker: worker)
		let presenter = DestinationPickerPresenter()

		destinationVC.interactor = interactor
		destinationVC.delegate = self
		interactor.presenter = presenter
		presenter.viewController = destinationVC

		viewController?.present(destinationVC, animated: true)
	}

	func routeToRoomGuestsPicker() {
		let roomGuestsVC = RoomGuestsPickerViewController()
		let interactor = RoomGuestsPickerInteractor()
		let presenter = RoomGuestsPickerPresenter()

		roomGuestsVC.interactor = interactor
		interactor.presenter = presenter
		presenter.viewController = roomGuestsVC

		viewController?.present(roomGuestsVC, animated: true)
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

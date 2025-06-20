//
//  DestinationPickerPresenter.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 19/6/25.
//

import Foundation

protocol DestinationPickerPresentationLogic {
	func presentDestinations(response: DestinationPickerModels.Search.Response)
	func presentSelectedDestination(response: DestinationPickerModels.Select.Response)
	func presentSearchError(_ error: Error)
}

final class DestinationPickerPresenter: DestinationPickerPresentationLogic {
	weak var viewController: DestinationPickerDisplayLogic?

	func presentDestinations(response: DestinationPickerModels.Search.Response) {
		let viewModel = DestinationPickerModels.Search.ViewModel(
			destinations: response.destinations.map { $0.label }
		)
		viewController?.displayDestinations(viewModel: viewModel)
	}

	func presentSelectedDestination(response: DestinationPickerModels.Select.Response) {
		let viewModel = DestinationPickerModels.Select.ViewModel(selected: response.selected)
		viewController?.displaySelectedDestination(viewModel: viewModel)
	}

	func presentSearchError(_ error: any Error) {
		let viewModel = DestinationPickerModels.Search.ErrorViewModel(message: error.localizedDescription)
		viewController?.displaySearchError(viewModel: viewModel)
	}
}

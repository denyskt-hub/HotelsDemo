//
//  DestinationPickerPresenter.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 19/6/25.
//

import Foundation

protocol DestinationPickerPresentationLogic {
	func presentDestinations(response: DestinationPickerModels.Response)

}

final class DestinationPickerPresenter: DestinationPickerPresentationLogic {
	weak var viewController: DestinationPickerDisplayLogic?

	func presentDestinations(response: DestinationPickerModels.Response) {
		let viewModel = DestinationPickerModels.ViewModel(
			destinations: response.destinations.map { $0.label }
		)
		viewController?.displayDestinations(viewModel: viewModel)
	}
}

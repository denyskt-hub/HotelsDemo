//
//  DestinationPickerPresenter.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 19/6/25.
//

import Foundation

public final class DestinationPickerPresenter: DestinationPickerPresentationLogic {
	public weak var viewController: DestinationPickerDisplayLogic?

	public init() {
		// Required for initialization in tests
	}

	public func presentDestinations(response: DestinationPickerModels.Search.Response) {
		let viewModel = DestinationPickerModels.Search.ViewModel(
			destinations: response.destinations.map {
				.init(
					title: $0.name,
					subtitle: [$0.cityName, $0.country]
						.filter { !$0.isEmpty }
						.joined(separator: ", ")
				)
			}
		)
		viewController?.displayDestinations(viewModel: viewModel)
		viewController?.hideSearchError()
	}

	public func presentSelectedDestination(response: DestinationPickerModels.DestinationSelection.Response) {
		let viewModel = DestinationPickerModels.DestinationSelection.ViewModel(selected: response.selected)
		viewController?.displaySelectedDestination(viewModel: viewModel)
	}

	public func presentSearchError(_ error: Error) {
		let viewModel = DestinationPickerModels.Search.ErrorViewModel(message: error.localizedDescription)
		viewController?.displaySearchError(viewModel: viewModel)
	}
}

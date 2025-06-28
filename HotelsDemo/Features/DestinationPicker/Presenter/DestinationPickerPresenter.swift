//
//  DestinationPickerPresenter.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 19/6/25.
//

import Foundation

public final class DestinationPickerPresenter: DestinationPickerPresentationLogic {
	public weak var viewController: DestinationPickerDisplayLogic?

	public init() {}

	public func presentDestinations(response: DestinationPickerModels.Search.Response) {
		let viewModel = DestinationPickerModels.Search.ViewModel(
			destinations: response.destinations.map { $0.label }
		)
		viewController?.displayDestinations(viewModel: viewModel)
		viewController?.hideSearchError()
	}

	public func presentSelectedDestination(response: DestinationPickerModels.Select.Response) {
		let viewModel = DestinationPickerModels.Select.ViewModel(selected: response.selected)
		viewController?.displaySelectedDestination(viewModel: viewModel)
	}

	public func presentSearchError(_ error: Error) {
		let viewModel = DestinationPickerModels.Search.ErrorViewModel(message: error.localizedDescription)
		viewController?.displaySearchError(viewModel: viewModel)
	}
}

//
//  SearchPresenter.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 12/7/25.
//

import Foundation

public final class SearchPresenter: SearchPresentationLogic {
	public weak var viewController: SearchDisplayLogic?

	public func presentSearch(response: SearchModels.Search.Response) {
		let viewModel = SearchModels.Search.ViewModel(
			hotels: response.hotels.map {
				.init(name: $0.name, position: $0.position)
			}
		)
		viewController?.displaySearch(viewModel: viewModel)
	}

	public func presentSearchError(_ error: Error) {
		let viewModel = SearchModels.ErrorViewModel(message: error.localizedDescription)
		viewController?.displaySearchError(viewModel: viewModel)
	}
}

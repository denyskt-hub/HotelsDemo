//
//  SearchPresenter.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 12/7/25.
//

import Foundation

public final class SearchPresenter: SearchPresentationLogic {
	public var viewController: SearchDisplayLogic?

	public func presentSearch(response: SearchModels.Search.Response) {
		let viewModel = SearchModels.Search.ViewModel(
			hotels: response.hotels.map {
				.init(
					position: $0.position,
					starRating: $0.starRating,
					name: $0.name,
					score: "\($0.reviewScore)",
					reviews: "\($0.reviewsCount) reviews",
					price: "\($0.price.currency) \($0.price.grossPrice)",
					priceDetails: "Includes taxes and fees",
					photoURL: $0.photoURLs.first
				)
			}
		)
		viewController?.displaySearch(viewModel: viewModel)
	}

	public func presentSearchError(_ error: Error) {
		let viewModel = SearchModels.ErrorViewModel(message: error.localizedDescription)
		viewController?.displaySearchError(viewModel: viewModel)
	}
}

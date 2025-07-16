//
//  SearchPresenter.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 12/7/25.
//

import Foundation

public final class SearchPresenter: SearchPresentationLogic {
	private let priceFormatter: NumberFormatter = {
		let formatter = NumberFormatter()
		formatter.numberStyle = .currency
		return formatter
	}()

	public var viewController: SearchDisplayLogic?

	public func presentSearch(response: SearchModels.Search.Response) {
		let viewModel = SearchModels.Search.ViewModel(
			hotels: response.hotels.map {
				.init(
					position: $0.position,
					starRating: $0.starRating,
					name: $0.name,
					score: "\($0.reviewScore)",
					reviews: "\($0.reviewCount) reviews",
					price: priceFormatter.string($0.price),
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

extension NumberFormatter {
	func string(_ price: Price) -> String {
		currencyCode = price.currency
		return string(from: price.grossPrice as NSNumber) ?? "\(price.currency) \(price)"
	}
}

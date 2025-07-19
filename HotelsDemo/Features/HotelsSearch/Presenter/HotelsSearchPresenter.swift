//
//  HotelsSearchPresenter.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 12/7/25.
//

import Foundation

public final class HotelsSearchPresenter: HotelsSearchPresentationLogic {
	private let priceFormatter: PriceFormatter

	public var viewController: HotelsSearchDisplayLogic?

	public init(priceFormatter: PriceFormatter) {
		self.priceFormatter = priceFormatter
	}

	public func presentSearch(response: HotelsSearchModels.Search.Response) {
		let viewModel = HotelsSearchModels.Search.ViewModel(
			hotels: response.hotels.map {
				.init(
					position: $0.position,
					starRating: $0.starRating,
					name: $0.name,
					score: "\($0.reviewScore)",
					reviews: "\($0.reviewCount) reviews",
					price: priceFormatter.string(from: $0.price),
					priceDetails: "Includes taxes and fees",
					photoURL: $0.photoURLs.first
				)
			}
		)
		viewController?.displaySearch(viewModel: viewModel)
	}

	public func presentSearchError(_ error: Error) {
		let viewModel = HotelsSearchModels.ErrorViewModel(message: error.localizedDescription)
		viewController?.displaySearchError(viewModel: viewModel)
	}
}

public final class PriceFormatter {
	private let numberFormatter: NumberFormatter

	public init(locale: Locale = .current) {
		let formatter = NumberFormatter()
		formatter.numberStyle = .currency
		formatter.locale = locale
		self.numberFormatter = formatter
	}

	public func string(from price: Price) -> String {
		numberFormatter.currencyCode = price.currency
		if let formatted = numberFormatter.string(from: price.grossPrice as NSNumber) {
			return formatted
		} else {
			return "\(price.currency) \(price.grossPrice)"
		}
	}
}

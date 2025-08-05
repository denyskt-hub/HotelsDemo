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
			hotels: makeHotelViewModels(response.hotels)
		)
		viewController?.displaySearch(viewModel: viewModel)
	}

	public func presentSearchLoading(_ isLoading: Bool) {
		let viewModel = HotelsSearchModels.LoadingViewModel(isLoading: isLoading)
		viewController?.displayLoading(viewModel: viewModel)
	}

	public func presentSearchError(_ error: Error) {
		let viewModel = HotelsSearchModels.ErrorViewModel(message: error.localizedDescription)
		viewController?.displaySearchError(viewModel: viewModel)
	}

	public func presentFilters(response: HotelsSearchModels.Filter.Response) {
		let viewModel = HotelsSearchModels.Filter.ViewModel(filters: response.filters)
		viewController?.displayFilters(viewModel: viewModel)
	}

	public func presentUpdateFilters(response: HotelsSearchModels.UpdateFilter.Response) {
		let viewModel = HotelsSearchModels.UpdateFilter.ViewModel(
			hotels: makeHotelViewModels(response.hotels),
			hasSelectedFilters: response.hasSelectedFilters
		)
		viewController?.displayUpdateFilters(viewModel: viewModel)
	}

	private func makeHotelViewModels(_ hotels: [Hotel]) -> [HotelsSearchModels.HotelViewModel] {
		hotels.map {
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

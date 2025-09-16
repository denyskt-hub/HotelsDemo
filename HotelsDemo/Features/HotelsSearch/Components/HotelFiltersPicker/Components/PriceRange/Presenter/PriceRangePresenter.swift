//
//  PriceRangePresenter.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 26/7/25.
//

import Foundation

public final class PriceRangePresenter: PriceRangePresentationLogic {
	private let locale: Locale

	public weak var viewController: PriceRangeDisplayLogic?

	public init(locale: Locale = .current) {
		self.locale = locale
	}

	public func present(response: PriceRangeModels.FetchPriceRange.Response) {
		let priceRange = response.priceRange ?? response.availablePriceRange
		let viewModel = PriceRangeModels.FetchPriceRange.ViewModel(
			priceRangeViewModel: .init(
				availablePriceRange: response.availablePriceRange,
				priceRange: priceRange,
				lowerValue: priceRange.lowerBound.formattedCurrency(code: response.currencyCode, locale: locale),
				upperValue: priceRange.upperBound.formattedCurrency(code: response.currencyCode, locale: locale)
			)
		)
		viewController?.display(viewModel: viewModel)
	}

	public func presentReset(response: PriceRangeModels.PriceRangeReset.Response) {
		let viewModel = PriceRangeModels.PriceRangeReset.ViewModel(
			priceRangeViewModel: .init(
				availablePriceRange: response.availablePriceRange,
				priceRange: response.availablePriceRange,
				lowerValue: response.availablePriceRange.lowerBound.formattedCurrency(code: response.currencyCode, locale: locale),
				upperValue: response.availablePriceRange.upperBound.formattedCurrency(code: response.currencyCode, locale: locale)
			)
		)
		viewController?.displayReset(viewModel: viewModel)
	}

	public func presentSelect(response: PriceRangeModels.PriceRangeSelection.Response) {
		let viewModel = PriceRangeModels.PriceRangeSelection.ViewModel(
			priceRange: response.priceRange
		)
		viewController?.displaySelect(viewModel: viewModel)
	}

	public func presentSelecting(response: PriceRangeModels.SelectingPriceRange.Response) {
		let viewModel = PriceRangeModels.SelectingPriceRange.ViewModel(
			lowerValue: response.priceRange.lowerBound.formattedCurrency(code: response.currencyCode, locale: locale),
			upperValue: response.priceRange.upperBound.formattedCurrency(code: response.currencyCode, locale: locale)
		)
		viewController?.displaySelecting(viewModel: viewModel)
	}
}

// MARK: - Helpers

extension Decimal {
	func formattedCurrency(code: String, locale: Locale = .current) -> String {
		let formatter = NumberFormatter()
		formatter.numberStyle = .currency
		formatter.currencyCode = code
		formatter.locale = locale
		return formatter.string(for: self) ?? "\(self)"
	}
}

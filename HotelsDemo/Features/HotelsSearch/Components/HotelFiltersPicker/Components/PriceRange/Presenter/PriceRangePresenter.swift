//
//  PriceRangePresenter.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 26/7/25.
//

import Foundation

public final class PriceRangePresenter: PriceRangePresentationLogic {
	public weak var viewController: PriceRangeDisplayLogic?

	public init() {
		// Required for initialization in tests
	}

	public func present(response: PriceRangeModels.Load.Response) {
		let priceRange = response.priceRange ?? response.availablePriceRange
		let viewModel = PriceRangeModels.Load.ViewModel(
			priceRangeViewModel: .init(
				availablePriceRange: response.availablePriceRange,
				priceRange: priceRange,
				lowerValue: priceRange.lowerBound.formattedCurrency(code: response.currencyCode),
				upperValue: priceRange.upperBound.formattedCurrency(code: response.currencyCode)
			)
		)
		viewController?.display(viewModel: viewModel)
	}

	public func presentReset(response: PriceRangeModels.Reset.Response) {
		let viewModel = PriceRangeModels.Reset.ViewModel(
			availablePriceRange: response.availablePriceRange,
			lowerValue: response.availablePriceRange.lowerBound.formattedCurrency(code: response.currencyCode),
			upperValue: response.availablePriceRange.upperBound.formattedCurrency(code: response.currencyCode)
		)
		viewController?.displayReset(viewModel: viewModel)
	}

	public func presentSelect(response: PriceRangeModels.Select.Response) {
		let viewModel = PriceRangeModels.Select.ViewModel(
			priceRange: response.priceRange
		)
		viewController?.displaySelect(viewModel: viewModel)
	}

	public func presentSelecting(response: PriceRangeModels.Selecting.Response) {
		let viewModel = PriceRangeModels.Selecting.ViewModel(
			lowerValue: response.priceRange.lowerBound.formattedCurrency(code: response.currencyCode),
			upperValue: response.priceRange.upperBound.formattedCurrency(code: response.currencyCode)
		)
		viewController?.displaySelecting(viewModel: viewModel)
	}
}

// MARK: - Helpers

extension Decimal {
	func formattedCurrency(code: String) -> String {
		formatted(.currency(code: code))
	}
}

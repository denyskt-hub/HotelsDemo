//
//  PriceRangeInteractor.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 26/7/25.
//

import Foundation

public final class PriceRangeInteractor: PriceRangeBusinessLogic {
	private let availablePriceRange: ClosedRange<Decimal> = 0...3000
	private var selectedPriceRange: ClosedRange<Decimal>?
	private let currencyCode: String

	public var presenter: PriceRangePresentationLogic?

	public init(
		selectedPriceRange: ClosedRange<Decimal>?,
		currencyCode: String
	) {
		self.selectedPriceRange = selectedPriceRange
		self.currencyCode = currencyCode
	}

	public func load(request: PriceRangeModels.Load.Request) {
		presenter?.present(
			response: .init(
				availablePriceRange: availablePriceRange,
				priceRange: selectedPriceRange,
				currencyCode: currencyCode
			)
		)
	}

	public func reset(request: PriceRangeModels.Reset.Request) {
		selectedPriceRange = nil
		presenter?.presentReset(
			response: .init(
				availablePriceRange: availablePriceRange,
				currencyCode: currencyCode
			)
		)
	}

	public func select(request: PriceRangeModels.Select.Request) {
		selectedPriceRange = request.priceRange
		presenter?.presentSelect(response: .init(priceRange: request.priceRange))
	}

	public func selecting(request: PriceRangeModels.Selecting.Request) {
		selectedPriceRange = request.priceRange
		presenter?.presentSelecting(
			response: .init(
				priceRange: request.priceRange,
				currencyCode: currencyCode
			)
		)
	}
}

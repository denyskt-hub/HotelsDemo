//
//  PriceRangePresenter.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 22/7/25.
//

import Foundation

public final class PriceRangeCellPresenter {
	public weak var view: PriceRangeView?

	public func presentSelectedRange(_ range: ClosedRange<Decimal>, currencyCode: String) {
		let viewModel = PriceRangeViewModel(
			lowerBound: range.lowerBound.formatted(.currency(code: currencyCode)),
			upperBound: range.upperBound.formatted(.currency(code: currencyCode))
		)
		view?.displayPriceRange(viewModel)
	}
}

public struct PriceRangeViewModel {
	public let lowerBound: String
	public let upperBound: String

	public init(
		lowerBound: String,
		upperBound: String
	) {
		self.lowerBound = lowerBound
		self.upperBound = upperBound
	}
}

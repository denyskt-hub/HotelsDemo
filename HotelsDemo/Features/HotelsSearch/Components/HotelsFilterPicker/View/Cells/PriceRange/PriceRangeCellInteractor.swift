//
//  PriceRangeInteractor.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 22/7/25.
//

import Foundation

public final class PriceRangeCellInteractor {
	private let currencyCode: String
	private var selectedPriceRange: ClosedRange<Decimal>?

	public var presenter: PriceRangeCellPresenter?

	public init(
		currencyCode: String,
		selectedRange: ClosedRange<Decimal>? = nil
	) {
		self.currencyCode = currencyCode
		self.selectedPriceRange = selectedRange
	}

	public func selectedRangeValueChanged(_ range: ClosedRange<Decimal>) {
		selectedPriceRange = range
		presenter?.presentSelectedRange(range, currencyCode: currencyCode)
	}
}

//
//  PriceRangeInteractor.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 22/7/25.
//

import Foundation

public final class PriceRangeInteractor {
	private let currencyCode: String
	private var selectedRange: ClosedRange<Decimal>?

	public var presenter: PriceRangePresenter?

	public init(
		currencyCode: String,
		selectedRange: ClosedRange<Decimal>? = nil
	) {
		self.currencyCode = currencyCode
		self.selectedRange = selectedRange
	}

	public func selectedRangeValueChanged(_ range: ClosedRange<Decimal>) {
		selectedRange = range
		presenter?.presentSelectedRange(range, currencyCode: currencyCode)
	}
}

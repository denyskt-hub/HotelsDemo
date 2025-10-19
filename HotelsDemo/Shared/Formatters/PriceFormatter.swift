//
//  PriceFormatter.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 19/10/25.
//

import Foundation

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

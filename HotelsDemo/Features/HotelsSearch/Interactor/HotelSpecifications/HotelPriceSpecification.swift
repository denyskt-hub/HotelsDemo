//
//  HotelPriceSpecification.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 21/7/25.
//

import Foundation

public struct HotelPriceSpecification: HotelSpecification {
	private let priceRange: ClosedRange<Decimal>

	public init(priceRange: ClosedRange<Decimal>) {
		self.priceRange = priceRange
	}

	public func isSatisfied(by item: Hotel) -> Bool {
		priceRange.contains(item.price.grossPrice)
	}
}

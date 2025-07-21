//
//  HotelsFilter.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 20/7/25.
//

import Foundation

public struct HotelsFilter {
	let priceRange: ClosedRange<Decimal>?
	let starRating: Int?
	let minimumReviewScore: Decimal?
}

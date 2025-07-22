//
//  PriceRangeView.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 22/7/25.
//

import Foundation

public protocol PriceRangeView: AnyObject {
	func displayPriceRange(_ viewModel: PriceRangeViewModel)
}

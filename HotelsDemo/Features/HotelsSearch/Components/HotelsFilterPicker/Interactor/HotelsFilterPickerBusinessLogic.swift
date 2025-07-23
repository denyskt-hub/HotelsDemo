//
//  HotelsFilterPickerBusinessLogic.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 20/7/25.
//

import Foundation

public protocol HotelsFilterPickerBusinessLogic {
	func load(request: HotelsFilterPickerModels.Load.Request)
	func updatePriceRange(request: HotelsFilterPickerModels.UpdatePriceRange.Request)
	func updateStarRatings(request: HotelsFilterPickerModels.UpdateStarRatings.Request)
	func selectFilter(request: HotelsFilterPickerModels.Select.Request)
}

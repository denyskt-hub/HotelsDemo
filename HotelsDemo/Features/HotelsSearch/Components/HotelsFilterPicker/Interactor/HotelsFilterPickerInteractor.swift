//
//  HotelsFilterPickerInteractor.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 20/7/25.
//

import Foundation

public final class HotelsFilterPickerInteractor: HotelsFilterPickerBusinessLogic {
	private var currentFilter: HotelsFilter

	public var presenter: HotelsFilterPickerPresentationLogic?

	public init(currentFilter: HotelsFilter) {
		self.currentFilter = currentFilter
	}

	public func load(request: HotelsFilterPickerModels.Load.Request) {
		presenter?.presentLoad(response: .init(filter: currentFilter))
	}

	public func updatePriceRange(request: HotelsFilterPickerModels.UpdatePriceRange.Request) {
		currentFilter.priceRange = request.priceRange
	}

	public func updateStarRatings(request: HotelsFilterPickerModels.UpdateStarRatings.Request) {
		currentFilter.starRatings = request.starRatings
	}

	public func selectFilter(request: HotelsFilterPickerModels.Select.Request) {
		presenter?.presentSelectedFilter(response: .init(filter: currentFilter))
	}
}

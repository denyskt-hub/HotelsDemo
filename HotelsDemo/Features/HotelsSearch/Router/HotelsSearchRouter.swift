//
//  HotelsSearchRouter.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 21/7/25.
//

import UIKit

public protocol HotelsSearchRoutingLogic {
	func routeToHotelFiltersPicker(viewModel: HotelsSearchModels.FetchFilters.ViewModel)
}

public final class HotelsSearchRouter: HotelsSearchRoutingLogic {
	public weak var viewController: HotelsSearchViewController?

	private let hotelFiltersPickerFactory: HotelFiltersPickerFactory

	public init(hotelFiltersPickerFactory: HotelFiltersPickerFactory) {
		self.hotelFiltersPickerFactory = hotelFiltersPickerFactory
	}

	public func routeToHotelFiltersPicker(viewModel: HotelsSearchModels.FetchFilters.ViewModel) {
		let filterVC = hotelFiltersPickerFactory
			.makeHotelFiltersPicker(filters: viewModel.filters, delegate: viewController)
			.embeddedInNavigationController()
		filterVC.modalPresentationStyle = .fullScreen
		viewController?.present(filterVC, animated: true)
	}
}

//
//  HotelsSearchRouter.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 21/7/25.
//

import UIKit

public protocol HotelsSearchRoutingLogic {
	func routeToHotelsFilterPicker(viewModel: HotelsSearchModels.Filter.ViewModel)
}

public final class HotelsSearchRouter: HotelsSearchRoutingLogic {
	public weak var viewController: HotelsSearchViewController?

	private let hotelFiltersPickerFactory: HotelFiltersPickerFactory

	public init(hotelFiltersPickerFactory: HotelFiltersPickerFactory) {
		self.hotelFiltersPickerFactory = hotelFiltersPickerFactory
	}

	public func routeToHotelsFilterPicker(viewModel: HotelsSearchModels.Filter.ViewModel) {
		let filterVC = hotelFiltersPickerFactory
			.makeHotelFiltersPicker(filters: viewModel.filter, delegate: viewController)
			.embeddedInNavigationController()
		filterVC.modalPresentationStyle = .fullScreen
		viewController?.present(filterVC, animated: true)
	}
}

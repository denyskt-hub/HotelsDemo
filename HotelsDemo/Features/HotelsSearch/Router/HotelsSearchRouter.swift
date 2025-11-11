//
//  HotelsSearchRouter.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 21/7/25.
//

import UIKit

@MainActor
public protocol HotelsSearchRoutingLogic {
	func routeToHotelFiltersPicker(_ filters: HotelFilters)
}

public final class HotelsSearchRouter: HotelsSearchRoutingLogic {
	private let hotelFiltersPickerFactory: HotelFiltersPickerFactory
	private let scene: HotelsSearchScene

	public init(
		hotelFiltersPickerFactory: HotelFiltersPickerFactory,
		scene: HotelsSearchScene
	) {
		self.hotelFiltersPickerFactory = hotelFiltersPickerFactory
		self.scene = scene
	}

	public func routeToHotelFiltersPicker(_ filters: HotelFilters) {
		let filterVC = hotelFiltersPickerFactory
			.makeHotelFiltersPicker(filters: filters, delegate: scene)
			.embeddedInNavigationController()
		filterVC.modalPresentationStyle = .fullScreen
		scene.present(filterVC)
	}
}

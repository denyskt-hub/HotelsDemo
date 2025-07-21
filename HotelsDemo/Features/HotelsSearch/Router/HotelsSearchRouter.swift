//
//  HotelsSearchRouter.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 21/7/25.
//

import UIKit

public protocol HotelsSearchRoutingLogic {
	func routeToHotelsFilterPicker()
}

public final class HotelsSearchRouter: HotelsSearchRoutingLogic {
	public weak var viewController: HotelsSearchViewController?

	private let hotelsFilterPickerFactory: HotelsFilterPickerFactory

	public init(hotelsFilterPickerFactory: HotelsFilterPickerFactory) {
		self.hotelsFilterPickerFactory = hotelsFilterPickerFactory
	}

	public func routeToHotelsFilterPicker() {
		let filterVC = hotelsFilterPickerFactory
			.makeFilter()
			.embeddedInNavigationController()
		filterVC.modalPresentationStyle = .fullScreen
		viewController?.present(filterVC, animated: true)
	}
}

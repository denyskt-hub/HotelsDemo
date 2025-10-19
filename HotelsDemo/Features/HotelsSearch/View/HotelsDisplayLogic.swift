//
//  HotelsDisplayLogic.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 19/10/25.
//

import Foundation

public protocol HotelsDisplayLogic: AnyObject {
	func displayCellControllers(_ cellControllers: [HotelCellController])
	func displayFiltersBadge(_ isBadgeVisible: Bool)
	func displayLoading(_ isLoading: Bool)
	func displayErrorMessage(_ message: String)
	func displayFilters(_ filters: HotelFilters)
}

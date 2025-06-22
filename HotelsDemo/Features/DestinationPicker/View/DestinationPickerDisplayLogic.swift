//
//  DestinationPickerDisplayLogic.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 21/6/25.
//

import Foundation

protocol DestinationPickerDisplayLogic: AnyObject {
	func displayDestinations(viewModel: DestinationPickerModels.Search.ViewModel)
	func displaySelectedDestination(viewModel: DestinationPickerModels.Select.ViewModel)
	func displaySearchError(viewModel: DestinationPickerModels.Search.ErrorViewModel)
	func hideSearchError()
}

//
//  DestinationPickerPresentationLogic.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 21/6/25.
//

import Foundation

public protocol DestinationPickerPresentationLogic {
	func presentDestinations(response: DestinationPickerModels.Search.Response)
	func presentSelectedDestination(response: DestinationPickerModels.DestinationSelection.Response)
	func presentSearchError(_ error: Error)
}

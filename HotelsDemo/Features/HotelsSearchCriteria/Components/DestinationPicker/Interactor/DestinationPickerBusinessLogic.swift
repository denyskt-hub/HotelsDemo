//
//  DestinationPickerBusinessLogic.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 21/6/25.
//

import Foundation

public protocol DestinationPickerBusinessLogic {
	func doSearchDestinations(request: DestinationPickerModels.Search.Request)
	func handleDestinationSelection(request: DestinationPickerModels.DestinationSelection.Request)
}

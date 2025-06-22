//
//  DestinationPickerBusinessLogic.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 21/6/25.
//

import Foundation

protocol DestinationPickerBusinessLogic {
	func searchDestinations(request: DestinationPickerModels.Search.Request)
	func selectDestination(request: DestinationPickerModels.Select.Request)
}

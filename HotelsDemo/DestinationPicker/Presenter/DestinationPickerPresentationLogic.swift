//
//  DestinationPickerPresentationLogic.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 21/6/25.
//

import Foundation

protocol DestinationPickerPresentationLogic {
	func presentDestinations(response: DestinationPickerModels.Search.Response)
	func presentSelectedDestination(response: DestinationPickerModels.Select.Response)
	func presentSearchError(_ error: Error)
}

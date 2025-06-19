//
//  DestinationPickerInteractor.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 19/6/25.
//

import Foundation

protocol DestinationPickerBusinessLogic {
	func load(_ query: String)
}

final class DestinationPickerInteractor: DestinationPickerBusinessLogic {
	var presenter: DestinationPickerPresentationLogic?

	func load(_ query: String) {

	}
}

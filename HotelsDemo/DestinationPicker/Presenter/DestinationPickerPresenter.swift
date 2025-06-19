//
//  DestinationPickerPresenter.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 19/6/25.
//

import Foundation

protocol DestinationPickerPresentationLogic {
	func presentSuggestions(response: DestinationPickerModels.Response)

}

final class DestinationPickerPresenter: DestinationPickerPresentationLogic {
	weak var viewController: DestinationPickerDisplayLogic?

	func presentSuggestions(response: DestinationPickerModels.Response) {

	}
}

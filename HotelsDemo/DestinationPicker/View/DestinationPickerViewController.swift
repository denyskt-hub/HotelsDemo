//
//  DestinationPickerViewController.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 19/6/25.
//

import UIKit

protocol DestinationPickerDisplayLogic: AnyObject {
	func displaySuggestions(viewModel: DestinationPickerModels.ViewModel)
}

final class DestinationPickerViewController: NiblessViewController, DestinationPickerDisplayLogic {
	var interactor: DestinationPickerBusinessLogic?

	public override func loadView() {
		view = DestinationPickerRootView()
	}

	func displaySuggestions(viewModel: DestinationPickerModels.ViewModel) {
		// Update UI
	}
}

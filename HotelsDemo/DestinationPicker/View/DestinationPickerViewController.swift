//
//  DestinationPickerViewController.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 19/6/25.
//

import UIKit

protocol DestinationPickerDisplayLogic: AnyObject {
	func displayDestinations(viewModel: DestinationPickerModels.ViewModel)
}

final class DestinationPickerViewController: NiblessViewController, DestinationPickerDisplayLogic {
	var interactor: DestinationPickerBusinessLogic?

	private let rootView = DestinationPickerRootView()

	public override func loadView() {
		view = rootView
	}

	public override func viewDidLoad() {
		super.viewDidLoad()

		setupTextField()
	}

	private func setupTextField() {
		rootView.textField.delegate = self
	}

	public func displayDestinations(viewModel: DestinationPickerModels.ViewModel) {
		// Update UI
	}
}

extension DestinationPickerViewController: UITextFieldDelegate {
	func textField(
		_ textField: UITextField,
		shouldChangeCharactersIn range: NSRange,
		replacementString string: String
	) -> Bool {

		if let currentText = textField.text, let textRange = Range(range, in: currentText) {
			let updatedText = currentText.replacingCharacters(in: textRange, with: string)

			interactor?.searchDestinations(query: updatedText)
		}

		return true
	}

	func textFieldShouldClear(_ textField: UITextField) -> Bool {
		return true
	}

	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
}

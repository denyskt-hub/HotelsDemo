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
	private let rootView = DestinationPickerRootView()
	private var viewModel: DestinationPickerModels.ViewModel?

	var interactor: DestinationPickerBusinessLogic?

	public override func loadView() {
		view = rootView
	}

	public override func viewDidLoad() {
		super.viewDidLoad()

		setupTextField()
		setupTableView()
	}

	private func setupTextField() {
		rootView.textField.delegate = self
	}

	private func setupTableView() {
		rootView.tableView.delegate = self
		rootView.tableView.dataSource = self
	}

	public func displayDestinations(viewModel: DestinationPickerModels.ViewModel) {
		self.viewModel = viewModel
		rootView.tableView.reloadData()
	}
}

extension DestinationPickerViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		viewModel?.destinations.count ?? 0
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = UITableViewCell()
		cell.textLabel?.text = viewModel?.destinations[indexPath.row]
		return cell
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

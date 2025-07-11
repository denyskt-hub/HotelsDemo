//
//  DestinationPickerViewController.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 19/6/25.
//

import UIKit

public final class DestinationPickerViewController: NiblessViewController, DestinationPickerDisplayLogic {
	private let rootView = DestinationPickerRootView()
	private var viewModel = DestinationPickerModels.Search.ViewModel(destinations: [])

	public var interactor: DestinationPickerBusinessLogic?
	public weak var delegate: DestinationPickerDelegate?

	public var tableView: UITableView { rootView.tableView }
	public var textField: UITextField { rootView.textField }
	public var errorLabel: UILabel { rootView.errorLabel }
	private var errorContainer: UIView { rootView.errorContainer }

	public override func loadView() {
		view = rootView
	}

	public override func viewDidLoad() {
		super.viewDidLoad()

		setupTextField()
		setupTableView()
	}

	public override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()

		tableView.sizeTableHeaderToFit()
	}

	private func setupTextField() {
		textField.delegate = self
	}

	private func setupTableView() {
		tableView.delegate = self
		tableView.dataSource = self
		tableView.register(DestinationCell.self)

		tableView.tableHeaderView = rootView.errorContainer
	}

	public func displayDestinations(viewModel: DestinationPickerModels.Search.ViewModel) {
		self.viewModel = viewModel
		tableView.reloadData()
	}

	public func displaySelectedDestination(viewModel: DestinationPickerModels.Select.ViewModel) {
		delegate?.didSelectDestination(viewModel.selected)
		dismiss(animated: true)
	}

	public func displaySearchError(viewModel: DestinationPickerModels.Search.ErrorViewModel) {
		errorLabel.text = viewModel.message
	}

	public func hideSearchError() {
		errorLabel.text = nil
	}
}

extension DestinationPickerViewController: UITableViewDataSource {
	public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		viewModel.destinations.count
	}

	public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell: DestinationCell = tableView.dequeueReusableCell()
		let viewModel = viewModel.destinations[indexPath.row]
		cell.titleLabel.text = viewModel.title
		cell.subtitleLabel.text = viewModel.subtitle
		return cell
	}
}

extension DestinationPickerViewController: UITableViewDelegate {
	public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		interactor?.selectDestination(request: DestinationPickerModels.Select.Request(index: indexPath.row))
	}
}

extension DestinationPickerViewController: UITextFieldDelegate {
	public func textField(
		_ textField: UITextField,
		shouldChangeCharactersIn range: NSRange,
		replacementString string: String
	) -> Bool {
		if let currentText = textField.text, let textRange = Range(range, in: currentText) {
			let updatedText = currentText.replacingCharacters(in: textRange, with: string)

			interactor?.searchDestinations(request: DestinationPickerModels.Search.Request(query: updatedText))
		}

		return true
	}

	public func textFieldShouldClear(_ textField: UITextField) -> Bool {
		return true
	}

	public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
}

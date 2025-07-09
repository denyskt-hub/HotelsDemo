//
//  AgePickerViewController.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 21/6/25.
//

import UIKit

public final class AgePickerViewController: NiblessViewController, UIPickerViewDelegate, UIPickerViewDataSource {
	public let options: [String]
	private(set) public var selectedIndex: Int?
	public let onSelect: (Int) -> Void

	public let pickerView = UIPickerView()

	public let doneButton: UIButton = {
		let button = UIButton(type: .system)
		button.setTitle("Done", for: .normal)
		return button
	}()

	public init(
		options: [String],
		selectedIndex: Int?,
		onSelect: @escaping (Int) -> Void
	) {
		self.options = options
		self.selectedIndex = selectedIndex
		self.onSelect = onSelect
		super.init()
	}

	public override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .systemBackground

		pickerView.dataSource = self
		pickerView.delegate = self
		view.addSubview(pickerView)
		pickerView.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			pickerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			pickerView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
		])

		if let selectedIndex {
			pickerView.selectRow(selectedIndex, inComponent: 0, animated: false)
		}

		doneButton.addTarget(self, action: #selector(doneTapped), for: .touchUpInside)

		navigationItem.rightBarButtonItem = UIBarButtonItem(customView: doneButton)
	}

	@objc private func doneTapped() {
		let selectedRow = pickerView.selectedRow(inComponent: 0)
		onSelect(selectedRow)
		dismiss(animated: true)
	}

	public func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }

	public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		options.count
	}

	public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		options[row]
	}
}

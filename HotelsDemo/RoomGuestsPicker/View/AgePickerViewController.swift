//
//  AgePickerViewController.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 21/6/25.
//

import UIKit

final class AgePickerViewController: NiblessViewController, UIPickerViewDelegate, UIPickerViewDataSource {
	private let options: [String]
	private var selectedIndex: Int?
	private let onSelect: (Int) -> Void

	private let pickerView = UIPickerView()

	init(
		options: [String],
		selectedIndex: Int?,
		onSelect: @escaping (Int) -> Void
	) {
		self.options = options
		self.selectedIndex = selectedIndex
		self.onSelect = onSelect
		super.init()
	}

	override func viewDidLoad() {
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

		navigationItem.rightBarButtonItem = UIBarButtonItem(
			barButtonSystemItem: .done,
			target: self,
			action: #selector(doneTapped)
		)
	}

	@objc private func doneTapped() {
		let selectedRow = pickerView.selectedRow(inComponent: 0)
		onSelect(selectedRow)
		dismiss(animated: true)
	}

	func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }

	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		options.count
	}

	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		options[row]
	}
}

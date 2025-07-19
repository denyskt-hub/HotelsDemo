//
//  AgePickerViewController.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 21/6/25.
//

import UIKit

public final class AgePickerViewController: NiblessViewController, UIPickerViewDelegate, UIPickerViewDataSource {
	private let rootView = AgePickerRootView()

	public let options: [String]
	private(set) public var selectedIndex: Int?
	public let onSelect: (Int) -> Void

	public var titleLabel: UILabel { rootView.titleLabel }
	public var pickerView: UIPickerView { rootView.pickerView }
	public var doneButton: UIButton { rootView.doneButton }

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

	public override func loadView() {
		view = rootView
	}

	public override func viewDidLoad() {
		super.viewDidLoad()

		titleLabel.text = title

		pickerView.dataSource = self
		pickerView.delegate = self

		if let selectedIndex {
			pickerView.selectRow(selectedIndex, inComponent: 0, animated: false)
		}

		doneButton.addTarget(self, action: #selector(doneTapped), for: .touchUpInside)
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

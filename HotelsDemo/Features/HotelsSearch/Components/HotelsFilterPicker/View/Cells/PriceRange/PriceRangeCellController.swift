//
//  PriceRangeCellController.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 22/7/25.
//

import UIKit

public protocol PriceRangeCellControllerDelegate: AnyObject {
	func didSelectPriceRange(_ priceRange: ClosedRange<Decimal>)
}

public final class PriceRangeCellController: NSObject {
	private let viewModel: HotelsFilterPickerModels.PriceRangeFilterOptionViewModel
	private let cell = PriceRangeCell()

	public var interactor: PriceRangeInteractor?
	public var delegate: PriceRangeCellControllerDelegate?

	public init(viewModel: HotelsFilterPickerModels.PriceRangeFilterOptionViewModel) {
		self.viewModel = viewModel
		super.init()

		setupCell()
		configureCell()
	}

	private func setupCell() {
		cell.slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
		cell.slider.addTarget(self, action: #selector(sliderEditingDidEnd(_:)), for: .editingDidEnd)
	}

	private func configureCell() {
		cell.configure(with: viewModel)
	}

	@objc private func sliderValueChanged(_ slider: RangeSlider) {
		interactor?.selectedRangeValueChanged(makePriceRange(slider.lowerValue, slider.upperValue))
	}

	@objc private func sliderEditingDidEnd(_ slider: RangeSlider) {
		delegate?.didSelectPriceRange(makePriceRange(slider.lowerValue, slider.upperValue))
	}

	private func makePriceRange(_ lowerValue: CGFloat, _ upperValue: CGFloat) -> ClosedRange<Decimal> {
		Decimal(lowerValue)...Decimal(upperValue)
	}
}

// MARK: - UITableViewDataSource

extension PriceRangeCellController: UITableViewDataSource {
	public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		1
	}

	public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		cell
	}
}

extension PriceRangeCellController: PriceRangeView {
	public func displayPriceRange(_ viewModel: PriceRangeViewModel) {
		cell.lowerValueLabel.text = viewModel.lowerBound
		cell.upperValueLabel.text = viewModel.upperBound
	}
}

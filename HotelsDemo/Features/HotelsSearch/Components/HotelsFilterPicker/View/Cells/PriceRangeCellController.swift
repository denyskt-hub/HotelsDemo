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

	public var delegate: PriceRangeCellControllerDelegate?

	public init(viewModel: HotelsFilterPickerModels.PriceRangeFilterOptionViewModel) {
		self.viewModel = viewModel
		super.init()

		setupCell()
		configureCell()
	}

	private func setupCell() {
		cell.slider.addTarget(self, action: #selector(rangeSliderValueChanged(_:)), for: .valueChanged)
	}

	private func configureCell() {
		cell.configure(with: viewModel)
	}

	@objc private func rangeSliderValueChanged(_ slider: RangeSlider) {
		delegate?.didSelectPriceRange(Decimal(slider.lowerValue)...Decimal(slider.upperValue))
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

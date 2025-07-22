//
//  PriceRangeCell.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 22/7/25.
//

import UIKit

public final class PriceRangeCell: UITableViewCell {
	public let slider: RangeSlider = {
		let slider = RangeSlider()
		let height = slider.heightAnchor.constraint(equalToConstant: 30)
		height.priority = UILayoutPriority(999)
		height.isActive = true
		return slider
	}()

	private lazy var selectedRangeStack: UIStackView = {
		let stackView = UIStackView(arrangedSubviews: [
			lowerValueLabel,
			upperValueLabel
		])
		stackView.axis = .horizontal
		stackView.distribution = .fillEqually
		return stackView
	}()

	public let lowerValueLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 13, weight: .medium)
		label.textColor = .secondaryLabel
		return label
	}()

	public let upperValueLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 13, weight: .medium)
		label.textColor = .secondaryLabel
		label.textAlignment = .right
		return label
	}()

	required public init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)

		setupHierarchy()
		activateConstraints()
	}

	private func setupHierarchy() {
		contentView.addSubview(slider)
		contentView.addSubview(selectedRangeStack)
	}

	private func activateConstraints() {
		activateConstraintsSlider()
		activateConstraintsSelectedRangeStack()
	}

	public func configure(with viewModel: HotelsFilterPickerModels.PriceRangeFilterOptionViewModel) {
		self.viewModel = viewModel

		slider.minimumValue = CGFloat((viewModel.minPrice as NSDecimalNumber).doubleValue)
		slider.maximumValue = CGFloat((viewModel.maxPrice as NSDecimalNumber).doubleValue)

		slider.lowerValue = CGFloat(((viewModel.selectedRange?.lowerBound ?? viewModel.minPrice) as NSDecimalNumber).doubleValue)
		slider.upperValue = CGFloat(((viewModel.selectedRange?.upperBound ?? viewModel.maxPrice) as NSDecimalNumber).doubleValue)

		lowerValueLabel.text = viewModel.minPrice.formatted(.currency(code: viewModel.currencyCode))
		upperValueLabel.text = viewModel.maxPrice.formatted(.currency(code: viewModel.currencyCode))
	}

	private var viewModel: HotelsFilterPickerModels.PriceRangeFilterOptionViewModel?
}

// MARK: - Layout

extension PriceRangeCell {
	private func activateConstraintsSlider() {
		slider.translatesAutoresizingMaskIntoConstraints = false
		let leading = slider.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor)
		let trailing = slider.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor)
		let top = slider.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor)
		NSLayoutConstraint.activate([leading, trailing, top])
	}

	private func activateConstraintsSelectedRangeStack() {
		selectedRangeStack.translatesAutoresizingMaskIntoConstraints = false
		let leading = selectedRangeStack.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor)
		let trailing = selectedRangeStack.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor)
		let top = selectedRangeStack.topAnchor.constraint(equalTo: slider.bottomAnchor)
		let bottom = selectedRangeStack.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor)
		NSLayoutConstraint.activate([leading, trailing, top, bottom])
	}
}

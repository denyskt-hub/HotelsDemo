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
		slider.minimumValue = viewModel.minPrice.cgFloatValue
		slider.maximumValue = viewModel.maxPrice.cgFloatValue

		let lowerValue = viewModel.selectedRange?.lowerBound ?? viewModel.minPrice
		let upperValue = viewModel.selectedRange?.upperBound ?? viewModel.maxPrice

		slider.lowerValue = lowerValue.cgFloatValue
		slider.upperValue = upperValue.cgFloatValue

		lowerValueLabel.text = lowerValue.formattedCurrency(code: viewModel.currencyCode)
		upperValueLabel.text = upperValue.formattedCurrency(code: viewModel.currencyCode)
	}
}

// MARK: - Layout

extension PriceRangeCell {
	private func activateConstraintsSlider() {
		slider.translatesAutoresizingMaskIntoConstraints = false
		let leading = slider.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10)
		let trailing = slider.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
		let top = slider.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor)
		NSLayoutConstraint.activate([leading, trailing, top])
	}

	private func activateConstraintsSelectedRangeStack() {
		selectedRangeStack.translatesAutoresizingMaskIntoConstraints = false
		let leading = selectedRangeStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10)
		let trailing = selectedRangeStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
		let top = selectedRangeStack.topAnchor.constraint(equalTo: slider.bottomAnchor, constant: 4)
		let bottom = selectedRangeStack.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor)
		NSLayoutConstraint.activate([leading, trailing, top, bottom])
	}
}

// MARK: - Helpers

extension Decimal {
	var cgFloatValue: CGFloat {
		NSDecimalNumber(decimal: self).doubleValue.cgFloatValue
	}
}

extension Decimal {
	func formattedCurrency(code: String) -> String {
		formatted(.currency(code: code))
	}
}

extension Double {
	var cgFloatValue: CGFloat {
		CGFloat(self)
	}
}

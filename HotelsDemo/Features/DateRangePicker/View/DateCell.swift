//
//  DayCell.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 22/6/25.
//

import UIKit

protocol DateCellDelegate: AnyObject {
	func dateCellDidTap(_ cell: DateCell)
}

final class DateCell: UICollectionViewCell {
	private let button: UIButton = {
		let button = UIButton()
		button.configure(.plain)
		button.tintColor = .label
		return button
	}()

	public weak var delegate: DateCellDelegate?

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override init(frame: CGRect = .zero) {
		super.init(frame: frame)

		setupHierarchy()
		setupButton()
		activateConstraints()
	}

	private func setupHierarchy() {
		contentView.addSubview(button)
	}

	private func setupButton() {
		button.addTarget(self, action: #selector(buttonHandler), for: .touchUpInside)
	}

	private func activateConstraints() {
		activateConstraintsButton()
	}

	public func configure(_ viewModel: DateRangePickerModels.CalendarDateViewModel) {
		button.setTitle(viewModel.title ?? "", for: .normal)
		button.tintColor = viewModel.isToday ? .blue : .label
		button.isEnabled = viewModel.isEnabled
		button.backgroundColor = viewModel.isSelected ? .cyan : (viewModel.isInRange ? .lightGray : .clear)
	}

	@objc private func buttonHandler() {
		delegate?.dateCellDidTap(self)
	}
}

// MARK: - Layout

extension DateCell {
	private func activateConstraintsButton() {
		button.translatesAutoresizingMaskIntoConstraints = false
		let leading = button.leadingAnchor.constraint(equalTo: leadingAnchor)
		let trailing = button.trailingAnchor.constraint(equalTo: trailingAnchor)
		let top = button.topAnchor.constraint(equalTo: topAnchor)
		let bottom = button.bottomAnchor.constraint(equalTo: bottomAnchor)
		NSLayoutConstraint.activate([leading, trailing, top, bottom])
	}
}

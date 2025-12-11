//
//  DayCell.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 22/6/25.
//

import UIKit

public final class DateCell: UICollectionViewCell {
	public let titleLabel: UILabel = {
		let label = UILabel()
		label.textColor = .label
		label.textAlignment = .center
		return label
	}()

	private(set) public var isToday: Bool = false
	private(set) public var isSelectedDate: Bool = false
	private(set) public var isInRange: Bool = false

	public required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	public override init(frame: CGRect = .zero) {
		super.init(frame: frame)

		setupHierarchy()
		activateConstraints()
	}

	private func setupHierarchy() {
		contentView.addSubview(titleLabel)
	}

	private func activateConstraints() {
		activateConstraintsTitleLabel()
	}

	public func configure(_ viewModel: DateRangePickerModels.CalendarDateViewModel) {
		isToday = viewModel.isToday
		isSelectedDate = viewModel.isSelected
		isInRange = viewModel.isInRange

		titleLabel.text = viewModel.title ?? ""
		titleLabel.isEnabled = viewModel.isEnabled

		switch viewModel.rangePosition {
		case .none:
			titleLabel.backgroundColor = .clear
			titleLabel.textColor = viewModel.isToday ? .systemBlue : .label
			titleLabel.clearCornerRadius()
		case .start:
			titleLabel.backgroundColor = .systemBlue
			titleLabel.textColor = .white
			titleLabel.roundCorners([.topLeft, .bottomLeft])
		case .middle:
			titleLabel.backgroundColor = .systemGray5
			titleLabel.textColor = .label
			titleLabel.clearCornerRadius()
		case .end:
			titleLabel.backgroundColor = .systemBlue
			titleLabel.textColor = .white
			titleLabel.roundCorners([.topRight, .bottomRight])
		case .single:
			titleLabel.backgroundColor = .systemBlue
			titleLabel.textColor = .white
			titleLabel.roundAllCorners()
		}
	}
}

// MARK: - Layout

extension DateCell {
	private func activateConstraintsTitleLabel() {
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		let leading = titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
		let trailing = titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
		let top = titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor)
		let bottom = titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
		NSLayoutConstraint.activate([leading, trailing, top, bottom])
	}
}

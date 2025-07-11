//
//  DayCell.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 22/6/25.
//

import UIKit

public protocol DateCellDelegate: AnyObject {
	func dateCellDidTap(_ cell: DateCell, at indexPath: IndexPath)
}

public final class DateCell: UICollectionViewCell {
	public let button: UIButton = {
		let button = UIButton()
		button.configure(.plain)
		button.tintColor = .label
		return button
	}()

	private(set) public var isToday: Bool = false
	private(set) public var isSelectedDate: Bool = false
	private(set) public var isInRange: Bool = false

	public weak var delegate: DateCellDelegate?
	public var indexPath: IndexPath?

	public required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	public override init(frame: CGRect = .zero) {
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
		isToday = viewModel.isToday
		isSelectedDate = viewModel.isSelected
		isInRange = viewModel.isInRange

		button.setTitle(viewModel.title ?? "", for: .normal)
		button.isEnabled = viewModel.isEnabled

		let radius: CGFloat = 8

		switch viewModel.rangePosition {
		case .none:
			button.backgroundColor = .clear
			button.tintColor = viewModel.isToday ? .blue : .label
			button.clearCornerRadius()
		case .start:
			button.backgroundColor = .systemBlue
			button.tintColor = .white
			button.roundCorners([.topLeft, .bottomLeft], radius: radius)
		case .middle:
			button.backgroundColor = .systemGray5
			button.tintColor = .label
			button.clearCornerRadius()
		case .end:
			button.backgroundColor = .systemBlue
			button.tintColor = .white
			button.roundCorners([.topRight, .bottomRight], radius: radius)
		case .single:
			button.backgroundColor = .systemBlue
			button.tintColor = .white
			button.roundAllCorners(radius: radius)
		}
	}

	@objc private func buttonHandler() {
		guard let indexPath = indexPath else { return }
		delegate?.dateCellDidTap(self, at: indexPath)
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


enum Corner {
	case topLeft
	case topRight
	case bottomLeft
	case bottomRight
}

extension UIView {
	func roundCorners(_ corners: [Corner], radius: CGFloat) {
		layer.cornerRadius = radius
		layer.maskedCorners = CACornerMask(from: corners)
		layer.masksToBounds = true
	}

	func roundAllCorners(radius: CGFloat) {
		roundCorners([.topLeft, .topRight, .bottomLeft, .bottomRight], radius: radius)
	}

	func clearCornerRadius() {
		layer.cornerRadius = 0
		layer.maskedCorners = []
	}
}

private extension CACornerMask {
	init(from corners: [Corner]) {
		self = []

		for corner in corners {
			switch corner {
			case .topLeft: self.insert(.layerMinXMinYCorner)
			case .topRight: self.insert(.layerMaxXMinYCorner)
			case .bottomLeft: self.insert(.layerMinXMaxYCorner)
			case .bottomRight: self.insert(.layerMaxXMaxYCorner)
			}
		}
	}
}

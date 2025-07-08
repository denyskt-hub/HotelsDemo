//
//  DestinationCell.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 8/7/25.
//

import UIKit

public final class DestinationCell: UITableViewCell {
	public let label: UILabel = {
		let label = UILabel()
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
		contentView.addSubview(label)
	}

	private func activateConstraints() {
		activateConstraintsLabel()
	}
}

// MARK: - Layout

extension DestinationCell {
	private func activateConstraintsLabel() {
		label.translatesAutoresizingMaskIntoConstraints = false
		let leading = label.leadingAnchor.constraint(equalTo: leadingAnchor)
		let trailing = label.trailingAnchor.constraint(equalTo: trailingAnchor)
		let top = label.topAnchor.constraint(equalTo: topAnchor)
		let bottom = label.bottomAnchor.constraint(equalTo: bottomAnchor)
		NSLayoutConstraint.activate([leading, trailing, top, bottom])
	}
}

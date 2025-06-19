//
//  DestinationPickerRootView.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 19/6/25.
//

import UIKit

public class DestinationPickerRootView: NiblessView {
	private var hierarchyNotReady = true

	public let label: UILabel = {
		let label = UILabel()
		label.text = "Destination"
		return label
	}()

	override public func didMoveToWindow() {
		super.didMoveToWindow()

		guard hierarchyNotReady else {
			return
		}

		setupAppearance()
		setupHierarchy()
		activateConstraints()
		hierarchyNotReady = false
	}

	private func setupAppearance() {
		backgroundColor = .systemBackground
	}

	private func setupHierarchy() {
		addSubview(label)
	}

	private func activateConstraints() {
		activateConstraintsLabel()
	}
}

// MARK: - Layout

extension DestinationPickerRootView {
	private func activateConstraintsLabel() {
		label.translatesAutoresizingMaskIntoConstraints = false
		let leading = label.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor)
		let trailing = label.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor)
		let top = label.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor)
		let bottom = label.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor)
		NSLayoutConstraint.activate([leading, trailing, top, bottom])
	}
}

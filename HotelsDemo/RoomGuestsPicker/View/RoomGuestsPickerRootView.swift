//
//  RoomGuestsPickerRootView.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 20/6/25.
//

import UIKit

public class RoomGuestsPickerRootView: NiblessView {
	private var hierarchyNotReady = true

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

	}

	private func activateConstraints() {

	}
}

// MARK: - Layout

extension RoomGuestsPickerRootView {

}

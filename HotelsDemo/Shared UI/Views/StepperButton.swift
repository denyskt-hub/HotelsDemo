//
//  StepperButton.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 10/7/25.
//

import UIKit

public final class StepperButton: UIButton {
	private let symbolName: String

	public init(systemImageName: String) {
		self.symbolName = systemImageName
		super.init(frame: .zero)
		setup()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func setup() {
		configureButton()
	}

	private func configureButton() {
		var config = UIButton.Configuration.plain()
		config.image = UIImage(systemName: symbolName)
		config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 14, weight: .semibold)
		config.contentInsets = .init(top: 4, leading: 4, bottom: 4, trailing: 4)
		config.baseForegroundColor = isEnabled ? .label : .systemGray3
		config.background.strokeColor = isEnabled ? .systemGray3 : .systemGray5
		config.background.strokeWidth = 1
		config.background.cornerRadius = 8
		configuration = config
	}

	public override var isEnabled: Bool {
		didSet {
			configureButton()
		}
	}
}

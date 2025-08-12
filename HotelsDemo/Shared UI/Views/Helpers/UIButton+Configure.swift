//
//  UIButton+Configure.swift
//  DemoAppFeaturesiOS
//
//  Created by Denys Kotenko on 12/3/25.
//

import UIKit

extension UIButton {
	enum Style {
		case plain
		case filled

		var configuration: UIButton.Configuration {
			switch self {
			case .plain:
				return .plain()

			case .filled:
				return .filled()
			}
		}
	}

	func configure(
		_ style: Style = .plain,
		title: String? = nil,
		font: UIFont? = nil,
		contentInsets: UIEdgeInsets? = nil
	) {
		var config = style.configuration

		if let title = title, let font = font {
			config.attributedTitle = AttributedString(title, attributes: AttributeContainer([.font: font]))
		} else {
			config.title = title
		}

		if let contentInsets = contentInsets {
			config.contentInsets = .init(
				top: contentInsets.top,
				leading: contentInsets.left,
				bottom: contentInsets.bottom,
				trailing: contentInsets.right
			)
		} else {
			config.setDefaultContentInsets()
		}

		config.imagePadding = 4

		configuration = config
	}
}

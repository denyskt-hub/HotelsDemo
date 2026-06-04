//
//  ConfigurationErrorViewController.swift
//  HotelsDemo
//

import UIKit

/// Shown instead of the app when the environment configuration is invalid,
/// so a misconfigured build explains itself instead of crashing.
final class ConfigurationErrorViewController: NiblessViewController {
	private let message: String

	let titleLabel: UILabel = {
		let label = UILabel()
		label.text = "Configuration Error"
		label.font = .preferredFont(forTextStyle: .title2)
		label.textAlignment = .center
		return label
	}()

	let messageLabel: UILabel = {
		let label = UILabel()
		label.font = .preferredFont(forTextStyle: .callout)
		label.textColor = .secondaryLabel
		label.textAlignment = .natural
		label.numberOfLines = 0
		return label
	}()

	private let iconView: UIImageView = {
		let imageView = UIImageView(image: UIImage(systemName: "exclamationmark.triangle"))
		imageView.tintColor = .systemOrange
		imageView.contentMode = .scaleAspectFit
		return imageView
	}()

	init(message: String) {
		self.message = message
		super.init()
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		view.backgroundColor = .systemBackground
		messageLabel.text = message
		setupLayout()
	}

	private func setupLayout() {
		let stack = UIStackView(arrangedSubviews: [iconView, titleLabel, messageLabel])
		stack.axis = .vertical
		stack.spacing = 16
		stack.translatesAutoresizingMaskIntoConstraints = false

		view.addSubview(stack)

		NSLayoutConstraint.activate([
			iconView.heightAnchor.constraint(equalToConstant: 48),
			stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
			stack.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 16),
			stack.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -16)
		])
	}
}

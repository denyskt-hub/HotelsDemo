//
//  StarRatingView.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 23/7/25.
//

import UIKit

public final class StarRatingView: NiblessView {
	private var hierarchyNotReady = true

	private lazy var stack: UIStackView = {
		let stack = UIStackView(arrangedSubviews: [])
		stack.axis = .horizontal
		stack.spacing = 2
		return stack
	}()

	public var rating: Int = 0 {
		didSet {
			updateStack(rating, starSize)
		}
	}

	public var starSize: StarSize = .medium {
		didSet {
			updateStack(rating, starSize)
		}
	}

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
		addSubview(stack)
	}

	private func activateConstraints() {
		activateConstraintsStack()
	}

	private func updateStack(_ rating: Int, _ starSize: StarSize) {
		stack.arrangedSubviews.forEach {
			$0.removeFromSuperview()
		}

		for _ in 0..<rating {
			let imageView = UIImageView()
			imageView.image = UIImage(systemName: "star.fill")
			imageView.contentMode = .scaleAspectFit
			imageView.widthAnchor.constraint(equalToConstant: starSize.size.width).isActive = true
			imageView.heightAnchor.constraint(equalToConstant: starSize.size.height).isActive = true
			stack.addArrangedSubview(imageView)
		}
	}
}

// MARK: - Layout

extension StarRatingView {
	private func activateConstraintsStack() {
		stack.translatesAutoresizingMaskIntoConstraints = false
		let leading = stack.leadingAnchor.constraint(equalTo: leadingAnchor)
		let trailing = stack.trailingAnchor.constraint(equalTo: trailingAnchor)
		let top = stack.topAnchor.constraint(equalTo: topAnchor)
		let bottom = stack.bottomAnchor.constraint(equalTo: bottomAnchor)
		NSLayoutConstraint.activate([leading, trailing, top, bottom])
	}
}

public enum StarSize {
	case small
	case medium
	case large
	case custom(CGSize)

	var size: CGSize {
		switch self {
		case .small: return CGSize(width: 12, height: 12)
		case .medium: return CGSize(width: 18, height: 18)
		case .large: return CGSize(width: 24, height: 24)
		case .custom(let size): return size
		}
	}
}

//
//  ShimmeringView.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 4/8/25.
//

import UIKit

public class ShimmeringView: UIView {
	private var shimmerLayer: CALayer?

	public var isShimmering: Bool {
		get { shimmerLayer != nil }
		set {
			if newValue {
				startShimmering()
			} else {
				stopShimmering()
			}
		}
	}

	private func startShimmering() {
		guard shimmerLayer == nil else { return }

		let shimmer = ShimmeringLayer(size: bounds.size)
		layer.addSublayer(shimmer)
		shimmerLayer = shimmer
	}

	private func stopShimmering() {
		shimmerLayer?.removeFromSuperlayer()
		shimmerLayer = nil
	}

	override public func layoutSubviews() {
		super.layoutSubviews()
		shimmerLayer?.frame = bounds
	}

	private class ShimmeringLayer: CAGradientLayer {
		private var observer: Any?

		deinit {
			if let observer = observer {
				NotificationCenter.default.removeObserver(observer)
			}
		}

		convenience init(size: CGSize) {
			self.init()

			let white = UIColor.white.cgColor
			let alpha = UIColor.white.withAlphaComponent(0.75).cgColor

			colors = [alpha, white, alpha]
			startPoint = CGPoint(x: 0.0, y: 0.4)
			endPoint = CGPoint(x: 1.0, y: 0.6)
			locations = [0.4, 0.5, 0.6]
			frame = CGRect(x: -size.width, y: 0, width: size.width * 3, height: size.height)

			let animation = CABasicAnimation(keyPath: #keyPath(CAGradientLayer.locations))
			animation.fromValue = [0.0, 0.1, 0.2]
			animation.toValue = [0.8, 0.9, 1.0]
			animation.duration = 1.25
			animation.repeatCount = .infinity
			add(animation, forKey: "shimmer")

			observer = NotificationCenter.default.addObserver(
				forName: UIApplication.willEnterForegroundNotification,
				object: nil,
				queue: nil
			) { [weak self] _ in
				self?.add(animation, forKey: "shimmer")
			}
		}
	}
}

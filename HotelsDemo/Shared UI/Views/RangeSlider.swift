//
//  RangeSlider.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 22/7/25.
//

import UIKit

public class RangeSlider: UIControl, RangeSliderPositionProvider {
	public override var frame: CGRect {
		didSet { updateLayerFrames() }
	}

	public var minimumValue: CGFloat = 0 {
		didSet { updateLayerFrames() }
	}

	public var maximumValue: CGFloat = 1 {
		didSet { updateLayerFrames() }
	}

	public var lowerValue: CGFloat = 0.2 {
		didSet { updateLayerFrames() }
	}

	public var upperValue: CGFloat = 0.8 {
		didSet { updateLayerFrames() }
	}

	public var trackTintColor = UIColor.secondarySystemBackground {
		didSet {
			trackLayer.trackTintColor = trackTintColor
			trackLayer.setNeedsDisplay()
		}
	}

	public var trackHighlightTintColor = UIColor.systemBlue {
		didSet {
			trackLayer.trackHighlightTintColor = trackHighlightTintColor
			trackLayer.setNeedsDisplay()
		}
	}

	public var thumbImage = UIImage.defaultThumb {
		didSet {
			upperThumbImageView.image = thumbImage
			lowerThumbImageView.image = thumbImage
		}
	}

	public var highlightedThumbImage = UIImage.defaultThumb {
		didSet {
			upperThumbImageView.highlightedImage = highlightedThumbImage
			lowerThumbImageView.highlightedImage = highlightedThumbImage
		}
	}

	private let trackLayer = RangeSliderTrackLayer()
	private let lowerThumbImageView = UIImageView()
	private let upperThumbImageView = UIImageView()
	private var previousLocation = CGPoint()

	public required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	public override init(frame: CGRect) {
		super.init(frame: frame)

		trackLayer.positionProvider = self
		trackLayer.contentsScale = UIScreen.main.scale
		layer.addSublayer(trackLayer)

		lowerThumbImageView.image = thumbImage
		lowerThumbImageView.highlightedImage = highlightedThumbImage
		addSubview(lowerThumbImageView)

		upperThumbImageView.image = thumbImage
		upperThumbImageView.highlightedImage = highlightedThumbImage
		addSubview(upperThumbImageView)
	}

	public override func layoutSubviews() {
		super.layoutSubviews()
		updateLayerFrames()
	}

	private func updateLayerFrames() {
		trackLayer.frame = bounds.insetBy(dx: thumbImage.size.width / 2, dy: bounds.height / 3)
		trackLayer.setNeedsDisplay()

		lowerThumbImageView.frame = CGRect(
			origin: thumbOriginForValue(lowerValue),
			size: thumbImage.size
		)
		upperThumbImageView.frame = CGRect(
			origin: thumbOriginForValue(upperValue),
			size: thumbImage.size
		)
	}

	internal func positionForValue(_ value: CGFloat) -> CGFloat {
		let range = maximumValue - minimumValue
		guard range != 0, bounds.width != 0 else { return 0 }
		let normalizedValue = (value - minimumValue) / range
		return (bounds.width - thumbImage.size.width) * normalizedValue
	}

	private func thumbOriginForValue(_ value: CGFloat) -> CGPoint {
		let x = positionForValue(value)
		return CGPoint(x: x, y: (bounds.height - thumbImage.size.height) / 2.0)
	}
}

extension RangeSlider {
	public override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
		previousLocation = touch.location(in: self)

		if lowerThumbImageView.frame.contains(previousLocation) {
			lowerThumbImageView.isHighlighted = true
		} else if upperThumbImageView.frame.contains(previousLocation) {
			upperThumbImageView.isHighlighted = true
		}

		sendActions(for: .editingDidBegin)
		return lowerThumbImageView.isHighlighted || upperThumbImageView.isHighlighted
	}

	public override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
		let location = touch.location(in: self)

		let deltaLocation = location.x - previousLocation.x
		let deltaValue = (maximumValue - minimumValue) * deltaLocation / (bounds.width - thumbImage.size.width)

		previousLocation = location

		if lowerThumbImageView.isHighlighted {
			lowerValue += deltaValue
			lowerValue = boundValue(
				lowerValue,
				toLowerValue: minimumValue,
				upperValue: upperValue
			)
		} else if upperThumbImageView.isHighlighted {
			upperValue += deltaValue
			upperValue = boundValue(
				upperValue,
				toLowerValue: lowerValue,
				upperValue: maximumValue
			)
		}

		sendActions(for: .valueChanged)
		return true
	}

	public override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
		lowerThumbImageView.isHighlighted = false
		upperThumbImageView.isHighlighted = false
		sendActions(for: .editingDidEnd)
	}

	private func boundValue(_ value: CGFloat, toLowerValue lowerValue: CGFloat, upperValue: CGFloat) -> CGFloat {
		min(max(value, lowerValue), upperValue)
	}

	public func positionForLowerValue() -> CGFloat {
		positionForValue(lowerValue)
	}

	public func positionForUpperValue() -> CGFloat {
		positionForValue(upperValue)
	}
}

protocol RangeSliderPositionProvider: AnyObject {
	func positionForLowerValue() -> CGFloat
	func positionForUpperValue() -> CGFloat
}

private class RangeSliderTrackLayer: CALayer {
	internal weak var positionProvider: RangeSliderPositionProvider?

	internal var trackTintColor: UIColor = .secondarySystemBackground
	internal var trackHighlightTintColor: UIColor = .systemBlue

	public override func draw(in ctx: CGContext) {
		guard let positionProvider = positionProvider else {
			return
		}

		let path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
		ctx.addPath(path.cgPath)

		ctx.setFillColor(trackTintColor.cgColor)
		ctx.fillPath()

		ctx.setFillColor(trackHighlightTintColor.cgColor)
		let lowerValuePosition = positionProvider.positionForLowerValue()
		let upperValuePosition = positionProvider.positionForUpperValue()
		let rect = CGRect(
			x: lowerValuePosition,
			y: 0,
			width: upperValuePosition - lowerValuePosition,
			height: bounds.height
		)
		ctx.fill(rect)
	}
}

extension UIImage {
	static let defaultThumb: UIImage = {
		UIImage(systemName: "circle.fill")!.applyingSymbolConfiguration(.init(pointSize: 24))!
	}()
}

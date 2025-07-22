//
//  RangeSlider.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 22/7/25.
//

import UIKit

public class RangeSlider: UIControl {
	public override var frame: CGRect {
		didSet {
			updateLayerFrames()
		}
	}

	public var minimumValue: CGFloat = 0 {
		didSet {
			updateLayerFrames()
		}
	}

	public var maximumValue: CGFloat = 1 {
		didSet {
			updateLayerFrames()
		}
	}

	public var lowerValue: CGFloat = 0.2 {
		didSet {
			updateLayerFrames()
		}
	}

	public var upperValue: CGFloat = 0.8 {
		didSet {
			updateLayerFrames()
		}
	}

	public var trackTintColor = UIColor(white: 0.9, alpha: 1) {
		didSet {
			trackLayer.setNeedsDisplay()
		}
	}

	public var trackHighlightTintColor = UIColor(red: 0, green: 0.45, blue: 0.94, alpha: 1) {
		didSet {
			trackLayer.setNeedsDisplay()
		}
	}

	public var thumbImage = UIImage(systemName: "circle.fill")! {
		didSet {
			upperThumbImageView.image = thumbImage
			lowerThumbImageView.image = thumbImage
			updateLayerFrames()
		}
	}

	public var highlightedThumbImage = UIImage(systemName: "circle.fill")! {
		didSet {
			upperThumbImageView.highlightedImage = highlightedThumbImage
			lowerThumbImageView.highlightedImage = highlightedThumbImage
			updateLayerFrames()
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

		trackLayer.rangeSlider = self
		trackLayer.contentsScale = UIScreen.main.scale
		layer.addSublayer(trackLayer)

		lowerThumbImageView.image = thumbImage
		addSubview(lowerThumbImageView)

		upperThumbImageView.image = thumbImage
		addSubview(upperThumbImageView)
	}

	public override func layoutSubviews() {
		super.layoutSubviews()
		updateLayerFrames()
	}

	private func updateLayerFrames() {
		CATransaction.begin()
		CATransaction.setDisableActions(true)

		trackLayer.frame = bounds.insetBy(dx: 0.0, dy: bounds.height / 3)
		trackLayer.setNeedsDisplay()

		lowerThumbImageView.frame = CGRect(
			origin: thumbOriginForValue(lowerValue),
			size: thumbImage.size
		)
		upperThumbImageView.frame = CGRect(
			origin: thumbOriginForValue(upperValue),
			size: thumbImage.size
		)

		CATransaction.commit()
	}

	internal func positionForValue(_ value: CGFloat) -> CGFloat {
		let maxNormalizedValue = maximumValue - minimumValue
		let normalizedValue = (value - minimumValue) / maxNormalizedValue
		return bounds.width * normalizedValue
	}

	private func thumbOriginForValue(_ value: CGFloat) -> CGPoint {
		let x = positionForValue(value) - thumbImage.size.width / 2.0
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

		return lowerThumbImageView.isHighlighted || upperThumbImageView.isHighlighted
	}

	public override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
		let location = touch.location(in: self)

		let deltaLocation = location.x - previousLocation.x
		let deltaValue = (maximumValue - minimumValue) * deltaLocation / bounds.width

		previousLocation = location

		if lowerThumbImageView.isHighlighted {
			lowerValue += deltaValue
			lowerValue = boundValue(
				lowerValue, toLowerValue: minimumValue,
				upperValue: upperValue
			)
		} else if upperThumbImageView.isHighlighted {
			upperValue += deltaValue
			upperValue = boundValue(
				upperValue, toLowerValue: lowerValue,
				upperValue: maximumValue
			)
		}

		sendActions(for: .valueChanged)
		return true
	}

	public override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
		lowerThumbImageView.isHighlighted = false
		upperThumbImageView.isHighlighted = false
	}

	private func boundValue(_ value: CGFloat, toLowerValue lowerValue: CGFloat, upperValue: CGFloat) -> CGFloat {
		min(max(value, lowerValue), upperValue)
	}
}

class RangeSliderTrackLayer: CALayer {
	internal weak var rangeSlider: RangeSlider?

	public override func draw(in ctx: CGContext) {
		guard let slider = rangeSlider else {
			return
		}

		let path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
		ctx.addPath(path.cgPath)

		ctx.setFillColor(slider.trackTintColor.cgColor)
		ctx.fillPath()

		ctx.setFillColor(slider.trackHighlightTintColor.cgColor)
		let lowerValuePosition = slider.positionForValue(slider.lowerValue)
		let upperValuePosition = slider.positionForValue(slider.upperValue)
		let rect = CGRect(
			x: lowerValuePosition,
			y: 0,
			width: upperValuePosition - lowerValuePosition,
			height: bounds.height
		)
		ctx.fill(rect)
	}
}

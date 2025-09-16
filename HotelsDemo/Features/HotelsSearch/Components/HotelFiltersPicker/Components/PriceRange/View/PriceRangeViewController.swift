//
//  PriceRangeViewController.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 26/7/25.
//

import UIKit

public protocol PriceRangeDelegate: AnyObject {
	func didSelectPriceRange(_ priceRange: ClosedRange<Decimal>?)
}

public final class PriceRangeViewController: NiblessViewController, PriceRangeDisplayLogic {
	private let rootView = PriceRangeRootView()

	public var interactor: PriceRangeBusinessLogic?
	public var delegate: PriceRangeDelegate?

	public var slider: RangeSlider { rootView.slider }
	public var lowerValueLabel: UILabel { rootView.lowerValueLabel }
	public var upperValueLabel: UILabel { rootView.upperValueLabel }

	public override func loadView() {
		view = rootView
	}

	public override func viewDidLoad() {
		super.viewDidLoad()

		setupSlider()

		interactor?.doFetchPriceRange(request: .init())
	}

	private func setupSlider() {
		slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
		slider.addTarget(self, action: #selector(sliderEditingDidEnd(_:)), for: .editingDidEnd)
	}

	public func display(viewModel: PriceRangeModels.FetchPriceRange.ViewModel) {
		display(viewModel.priceRangeViewModel)
	}

	public func displayReset(viewModel: PriceRangeModels.ResetPriceRange.ViewModel) {
		display(viewModel.priceRangeViewModel)
	}

	public func displaySelect(viewModel: PriceRangeModels.PriceRangeSelection.ViewModel) {
		delegate?.didSelectPriceRange(viewModel.priceRange)
	}

	public func displaySelecting(viewModel: PriceRangeModels.SelectingPriceRange.ViewModel) {
		lowerValueLabel.text = viewModel.lowerValue
		upperValueLabel.text = viewModel.upperValue
	}

	private func display(_ viewModel: PriceRangeModels.PriceRangeViewModel) {
		slider.minimumValue = viewModel.availablePriceRange.lowerBound.cgFloatValue
		slider.maximumValue = viewModel.availablePriceRange.upperBound.cgFloatValue

		slider.lowerValue = viewModel.priceRange.lowerBound.cgFloatValue
		slider.upperValue = viewModel.priceRange.upperBound.cgFloatValue

		lowerValueLabel.text = viewModel.lowerValue
		upperValueLabel.text = viewModel.upperValue
	}

	@objc private func sliderValueChanged(_ slider: RangeSlider) {
		interactor?.handleSelectingPriceRange(request: .init(priceRange: makePriceRange(slider.lowerValue, slider.upperValue)))
	}

	@objc private func sliderEditingDidEnd(_ slider: RangeSlider) {
		interactor?.handlePriceRangeSelection(request: .init(priceRange: makePriceRange(slider.lowerValue, slider.upperValue)))
	}

	private func makePriceRange(_ lowerValue: CGFloat, _ upperValue: CGFloat) -> ClosedRange<Decimal> {
		Decimal(lowerValue)...Decimal(upperValue)
	}
}

// MARK: - ResetableFilterViewController

extension PriceRangeViewController: ResetableFilterViewController {
	public func reset() {
		interactor?.handleResetPriceRange(request: .init())
	}
}

// MARK: - Helpers

public extension Decimal {
	var cgFloatValue: CGFloat {
		NSDecimalNumber(decimal: self).doubleValue.cgFloatValue
	}
}

public extension Double {
	var cgFloatValue: CGFloat {
		CGFloat(self)
	}
}

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
	}

	public override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()

		interactor?.load(request: .init())
	}

	private func setupSlider() {
		slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
		slider.addTarget(self, action: #selector(sliderEditingDidEnd(_:)), for: .editingDidEnd)
	}

	public func display(viewModel: PriceRangeModels.Load.ViewModel) {
		display(
			availablePriceRange: viewModel.availablePriceRange,
			priceRange: viewModel.priceRange,
			lowerValue: viewModel.lowerValue,
			upperValue: viewModel.upperValue
		)
	}

	public func displayReset(viewModel: PriceRangeModels.Reset.ViewModel) {
		display(
			availablePriceRange: viewModel.availablePriceRange,
			priceRange: viewModel.availablePriceRange,
			lowerValue: viewModel.lowerValue,
			upperValue: viewModel.upperValue
		)
	}

	public func displaySelect(viewModel: PriceRangeModels.Select.ViewModel) {
		delegate?.didSelectPriceRange(makePriceRange(slider.lowerValue, slider.upperValue))
	}

	public func displaySelecting(viewModel: PriceRangeModels.Selecting.ViewModel) {
		lowerValueLabel.text = viewModel.lowerValue
		upperValueLabel.text = viewModel.upperValue
	}

	private func display(
		availablePriceRange: ClosedRange<Decimal>,
		priceRange: ClosedRange<Decimal>,
		lowerValue: String,
		upperValue: String
	) {
		slider.minimumValue = availablePriceRange.lowerBound.cgFloatValue
		slider.maximumValue = availablePriceRange.upperBound.cgFloatValue

		slider.lowerValue = priceRange.lowerBound.cgFloatValue
		slider.upperValue = priceRange.upperBound.cgFloatValue

		lowerValueLabel.text = lowerValue
		upperValueLabel.text = upperValue
	}

	@objc private func sliderValueChanged(_ slider: RangeSlider) {
		interactor?.selecting(request: .init(priceRange: makePriceRange(slider.lowerValue, slider.upperValue)))
	}

	@objc private func sliderEditingDidEnd(_ slider: RangeSlider) {
		interactor?.select(request: .init(priceRange: makePriceRange(slider.lowerValue, slider.upperValue)))
	}

	private func makePriceRange(_ lowerValue: CGFloat, _ upperValue: CGFloat) -> ClosedRange<Decimal> {
		Decimal(lowerValue)...Decimal(upperValue)
	}
}

// MARK: - ResetableFilterViewController

extension PriceRangeViewController: ResetableFilterViewController {
	public func reset() {
		interactor?.reset(request: .init())
	}
}

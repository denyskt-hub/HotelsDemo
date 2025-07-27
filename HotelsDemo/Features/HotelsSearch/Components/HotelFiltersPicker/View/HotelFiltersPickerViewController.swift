//
//  HotelFiltersPickerViewController.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 25/7/25.
//

import UIKit

public protocol HotelFiltersPickerDelegate: AnyObject {
	func didSelectFilters(_ filters: HotelFilters)
}

public final class HotelFiltersPickerViewController: NiblessViewController, HotelFiltersPickerDisplayLogic {
	private let rootView = HotelFiltersPickerRootView()
	private let filterViewControllers: [ResetableFilterViewController]

	public var interactor: HotelFiltersPickerBusinessLogic?
	public weak var delegate: HotelFiltersPickerDelegate?

	public var contentStack: UIStackView { rootView.contentStack }
	public var applyButton: UIButton { rootView.applyButton }

	public init(filterViewControllers: [ResetableFilterViewController]) {
		self.filterViewControllers = filterViewControllers
		super.init()
	}

	public override func loadView() {
		view = rootView
	}

	public override func viewDidLoad() {
		super.viewDidLoad()

		setupTitle()
		setupNavigationBar()
		setupApplyButton()

		addChildren(filterViewControllers, to: contentStack)
	}

	private func setupTitle() {
		title = "Filters"
	}

	private func setupNavigationBar() {
		navigationItem.leftBarButtonItem = UIBarButtonItem(
			barButtonSystemItem: .close,
			target: self,
			action: #selector(close)
		)

		let resetButton = UIButton()
		resetButton.configure(title: "Reset")
		resetButton.addTarget(self, action: #selector(resetTapHandler), for: .touchUpInside)
		navigationItem.rightBarButtonItem = UIBarButtonItem(customView: resetButton)

		navigationController?.navigationBar.prefersLargeTitles = false
	}

	private func setupApplyButton() {
		applyButton.addTarget(self, action: #selector(applyTapHandler), for: .touchUpInside)
	}

	public func displaySelectedFilters(viewModel: HotelFiltersPickerModels.Select.ViewModel) {
		delegate?.didSelectFilters(viewModel.filters)
		dismiss(animated: true)
	}

	public func displayResetFilters(viewModel: HotelFiltersPickerModels.Reset.ViewModel) {
		filterViewControllers.forEach { $0.reset() }
	}

	@objc private func applyTapHandler() {
		interactor?.selectFilters(request: HotelFiltersPickerModels.Select.Request())
	}

	@objc private func resetTapHandler() {
		interactor?.resetFilters(request: HotelFiltersPickerModels.Reset.Request())
	}

	@objc private func close() {
		dismiss(animated: true)
	}
}

// MARK: - HotelFiltersScene

extension HotelFiltersPickerViewController: HotelFiltersScene {
	public func didSelectPriceRange(_ priceRange: ClosedRange<Decimal>?) {
		interactor?.updatePriceRange(request: .init(priceRange: priceRange))
	}

	public func didSelectStarRatings(_ starRatings: Set<StarRating>) {
		interactor?.updateStarRatings(request: .init(starRatings: starRatings))
	}

	public func didSelectReviewScore(_ reviewScore: ReviewScore?) {
		interactor?.updateReviewScore(request: .init(reviewScores: reviewScore != nil ? Set([reviewScore!]) : []))
	}
}

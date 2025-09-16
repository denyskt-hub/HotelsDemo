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
	public let resetButton: UIButton = {
		let button = UIButton()
		button.configure(title: "Reset")
		return button
	}()

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
		setupResetButton()

		addChildren(filterViewControllers, to: contentStack)

		interactor?.doFetchFilters(request: .init())
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

		navigationItem.rightBarButtonItem = UIBarButtonItem(customView: resetButton)

		navigationController?.navigationBar.prefersLargeTitles = false
	}

	private func setupApplyButton() {
		applyButton.addTarget(self, action: #selector(applyTapHandler), for: .touchUpInside)
	}

	private func setupResetButton() {
		resetButton.isEnabled = false
		resetButton.addTarget(self, action: #selector(resetTapHandler), for: .touchUpInside)
	}

	public func display(viewModel: HotelFiltersPickerModels.FetchFilters.ViewModel) {
		resetButton.isEnabled = viewModel.hasSelectedFilters
	}

	public func displaySelectedFilters(viewModel: HotelFiltersPickerModels.FilterSelection.ViewModel) {
		delegate?.didSelectFilters(viewModel.filters)
		dismiss(animated: true)
	}

	public func displayResetFilters(viewModel: HotelFiltersPickerModels.FilterReset.ViewModel) {
		filterViewControllers.forEach { $0.reset() }
	}

	@objc private func applyTapHandler() {
		interactor?.handleFilterSelection(request: .init())
	}

	@objc private func resetTapHandler() {
		interactor?.handleFilterReset(request: .init())
	}

	@objc private func close() {
		dismiss(animated: true)
	}
}

// MARK: - HotelFiltersScene

extension HotelFiltersPickerViewController: HotelFiltersScene {
	public func didSelectPriceRange(_ priceRange: ClosedRange<Decimal>?) {
		interactor?.handlePriceRangeSelection(request: .init(priceRange: priceRange))
	}

	public func didSelectStarRatings(_ starRatings: Set<StarRating>) {
		interactor?.handleStarRatingSelection(request: .init(starRatings: starRatings))
	}

	public func didSelectReviewScore(_ reviewScore: ReviewScore?) {
		interactor?.handleReviewScoreSelection(request: .init(reviewScore: reviewScore))
	}
}

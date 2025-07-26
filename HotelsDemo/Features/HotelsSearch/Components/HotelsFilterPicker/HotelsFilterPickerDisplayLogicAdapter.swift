//
//  HotelsFilterPickerDisplayLogicAdapter.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 21/7/25.
//

import UIKit

public final class HotelsFilterPickerDisplayLogicAdapter: HotelsFilterPickerDisplayLogic {
	private weak var viewController: HotelsFilterPickerViewController?

	public init(
		viewController: HotelsFilterPickerViewController,
	) {
		self.viewController = viewController
	}

	public func displayLoad(viewModel: HotelsFilterPickerModels.Load.ViewModel) {
		display(viewModel.filters)
	}

	public func displayResetFilter(viewModel: HotelsFilterPickerModels.Reset.ViewModel) {
		display(viewModel.filters)
	}

	public func displaySelectedFilter(viewModel: HotelsFilterPickerModels.Select.ViewModel) {
		viewController?.displaySelectedFilter(viewModel: viewModel)
	}

	private func display(_ filters: [HotelsFilterPickerModels.FilterViewModel]) {
		viewController?.display(makeFilterSections(from: filters))
	}

	private func makeFilterSections(from filters: [HotelsFilterPickerModels.FilterViewModel]) -> [FilterSection] {
		filters.map { filter in
			FilterSection(
				title: filter.title,
				cellControllers: makeCellControllers(for: filter)
			)
		}
	}

	private func makeCellControllers(for filter: HotelsFilterPickerModels.FilterViewModel) -> [CellController] {
		switch filter {
		case let .priceRange(viewModel):
			return [makePriceRangeCellController(viewModel)]
		case let .starRating(viewModels):
			return makeStarRatingCellControllers(viewModels)
		case let .reviewScore(viewModels):
			return makeReviewScoreCellControllers(viewModels)
		}
	}

	private func makePriceRangeCellController(
		_ viewModel: HotelsFilterPickerModels.PriceRangeFilterOptionViewModel
	) -> CellController {
		let view = PriceRangeCellController(viewModel: viewModel)
		let interactor = PriceRangeCellInteractor(
			currencyCode: viewModel.currencyCode,
			selectedRange: viewModel.selectedRange
		)
		let presenter = PriceRangeCellPresenter()

		view.interactor = interactor
		view.delegate = self
		interactor.presenter = presenter
		presenter.view = view

		return CellController(view)
	}

	private func makeStarRatingCellControllers(
		_ viewModels: [HotelsFilterPickerModels.FilterOptionViewModel<StarRating>]
	) -> [CellController] {
		let adapter = StarRatingSelectionAdapter(
			selectedStarRatings: Set(viewModels.compactMap { $0.isSelected ? $0.value : nil })
		)
		adapter.delegate = self

		return viewModels.map {
			let view = StarRatingCellController(viewModel: $0)
			view.delegate = adapter
			return CellController(view)
		}
	}

	private func makeReviewScoreCellControllers(
		_ viewModels: [HotelsFilterPickerModels.FilterOptionViewModel<ReviewScore>]
	) -> [CellController] {
		let adapter = ReviewScoreSelectionAdapter(
			selectedReivewScores: Set(viewModels.compactMap { $0.isSelected ? $0.value : nil })
		)
		adapter.delegate = self

		return viewModels.map {
			let view = ReviewScoreCellController(viewModel: $0)
			view.delegate = adapter
			return CellController(view)
		}
	}
}

// MARK: - PriceRangeCellControllerDelegate

extension HotelsFilterPickerDisplayLogicAdapter: PriceRangeCellControllerDelegate {
	public func didSelectPriceRange(_ priceRange: ClosedRange<Decimal>) {
		viewController?.interactor?.updatePriceRange(request: .init(priceRange: priceRange))
	}
}

// MARK: - StarRatingSelectionDelegate

extension HotelsFilterPickerDisplayLogicAdapter: StarRatingSelectionDelegate {
	public func didSelectStarRatings(_ starRatings: Set<StarRating>) {
		viewController?.interactor?.updateStarRatings(request: .init(starRatings: starRatings))
	}
}

// MARK: - ReviewScoreCellControllerDelegate

extension HotelsFilterPickerDisplayLogicAdapter: ReviewScoreSelectionDelegate {
	public func didSelectReviewScores(_ reviewScores: Set<ReviewScore>) {
		viewController?.interactor?.updateReviewScore(request: .init(reviewScores: reviewScores))
	}
}

// MARK: -

public struct FilterSection {
	public let title: String
	public let cellControllers: [CellController]

	public init(title: String, cellControllers: [CellController]) {
		self.title = title
		self.cellControllers = cellControllers
	}
}

extension HotelsFilterPickerModels.FilterViewModel {
	var title: String {
		switch self {
		case .priceRange:
			return "Price Range"
		case .starRating:
			return "Star Ratings"
		case .reviewScore:
			return "Review Score"
		}
	}
}

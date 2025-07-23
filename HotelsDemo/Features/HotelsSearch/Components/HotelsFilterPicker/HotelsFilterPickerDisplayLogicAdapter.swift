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
		viewController?.display(makeFilterSections(from: viewModel.filters))
	}

	public func displaySelectedFilter(viewModel: HotelsFilterPickerModels.Select.ViewModel) {
		viewController?.displaySelectedFilter(viewModel: viewModel)
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
		case .reviewScore:
			return []
		}
	}

	private func makePriceRangeCellController(
		_ viewModel: HotelsFilterPickerModels.PriceRangeFilterOptionViewModel
	) -> CellController {
		let view = PriceRangeCellController(viewModel: viewModel)
		let interactor = PriceRangeInteractor(
			currencyCode: viewModel.currencyCode,
			selectedRange: viewModel.selectedRange
		)
		let presenter = PriceRangePresenter()

		view.interactor = interactor
		view.delegate = self
		interactor.presenter = presenter
		presenter.view = view

		return CellController(view)
	}

	private func makeStarRatingCellControllers(
		_ viewModels: [HotelsFilterPickerModels.FilterOptionViewModel<Int>]
	) -> [CellController] {
		viewModels.map {
			CellController(StarRatingCellController(viewModel: $0))
		}
	}
}

extension HotelsFilterPickerDisplayLogicAdapter: PriceRangeCellControllerDelegate {
	public func didSelectPriceRange(_ priceRange: ClosedRange<Decimal>) {
		viewController?.interactor?.updatePriceRange(request: .init(priceRange: priceRange))
	}
}

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

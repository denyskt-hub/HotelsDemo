//
//  StarRatingInteractor.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 26/7/25.
//

import Foundation

public final class StarRatingInteractor: StarRatingBusinessLogic {
	private var selectedStarRatings = Set<StarRating>()

	public var presenter: StarRatingPresentationLogic?

	public init(selectedStarRatings: Set<StarRating>) {
		self.selectedStarRatings = selectedStarRatings
	}

	public func doFetchStarRating(request: StarRatingModels.FetchStarRating.Request) {
		presenter?.present(response: .init(options: makeOptions(selectedStarRatings)))
	}

	public func handleStarRatingReset(request: StarRatingModels.StarRatingReset.Request) {
		selectedStarRatings = []
		presenter?.presentReset(response: .init(options: makeOptions(selectedStarRatings)))
	}

	public func handleStarRatingSelection(request: StarRatingModels.StarRatingSelection.Request) {
		if selectedStarRatings.contains(request.starRating) {
			selectedStarRatings.remove(request.starRating)
		} else {
			selectedStarRatings.insert(request.starRating)
		}

		presenter?.presentSelect(
			response: .init(
				starRatings: selectedStarRatings,
				options: makeOptions(selectedStarRatings)
			)
		)
	}

	private func makeOptions(_ selectedStarRatings: Set<StarRating>) -> [StarRatingModels.Option] {
		StarRating.allCases.toOptions(selected: selectedStarRatings)
	}
}

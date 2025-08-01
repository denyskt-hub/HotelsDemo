//
//  StarRatingInteractorTests.swift
//  HotelsDemoTests
//
//  Created by Denys Kotenko on 31/7/25.
//

import XCTest
import HotelsDemo

final class StarRatingInteractorTests: XCTestCase {
	func test_load_presentsInitialState() {
		let cases: [(Set<StarRating>, String)] = [
			([], "when nothing selected"),
			([.five], "when .five is selected"),
			([.five, .four], "when .five and .four is selected")
		]

		cases.forEach { selected, desctiption in
			let (sut, presenter) = makeSUT(selectedStarRatings: selected)

			sut.load(request: .init())

			let expectedOptions = StarRating.allCases.toOptions(selected: selected)
			XCTAssertEqual(presenter.messages.last, .present(.init(options: expectedOptions)), description)
		}
	}

	func test_reset_presentsResetState() {
		let (sut, presenter) = makeSUT(selectedStarRatings: [.three])

		sut.reset(request: .init())

		let expectedOptions = StarRating.allCases.toOptions(selected: [])
		XCTAssertEqual(presenter.messages, [.presentReset(.init(options: expectedOptions))])
	}

	func test_select_presentsSelectedStarRatings() {
		let (sut, presenter) = makeSUT(selectedStarRatings: [])

		sut.select(request: .init(starRating: .five))

		XCTAssertEqual(presenter.messages, [
			.presentSelect(.init(starRatings: [.five], options: StarRating.allCases.toOptions(selected: [.five])))
		])
	}

	func test_selectAlreadySelectedStarRatings_presentsDeselectedStarRatings() {
		let (sut, presenter) = makeSUT(selectedStarRatings: [.five])

		sut.select(request: .init(starRating: .five))

		XCTAssertEqual(presenter.messages, [
			.presentSelect(.init(starRatings: [], options: StarRating.allCases.toOptions(selected: [])))
		])
	}

	// MARK: - Helpers

	private func makeSUT(selectedStarRatings: Set<StarRating> = []) -> (
		sut: StarRatingInteractor,
		presenter: StarRatingPresentationLogicSpy
	) {
		let presenter = StarRatingPresentationLogicSpy()
		let sut = StarRatingInteractor(selectedStarRatings: selectedStarRatings)
		sut.presenter = presenter
		return (sut, presenter)
	}
}

final class StarRatingPresentationLogicSpy: StarRatingPresentationLogic {
	enum Messages: Equatable {
		case present(StarRatingModels.Load.Response)
		case presentReset(StarRatingModels.Reset.Response)
		case presentSelect(StarRatingModels.Select.Response)
	}

	private(set) var messages = [Messages]()

	func present(response: StarRatingModels.Load.Response) {
		messages.append(.present(response))
	}
	
	func presentReset(response: StarRatingModels.Reset.Response) {
		messages.append(.presentReset(response))
	}
	
	func presentSelect(response: StarRatingModels.Select.Response) {
		messages.append(.presentSelect(response))
	}
}

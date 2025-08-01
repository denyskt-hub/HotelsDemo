//
//  StarRatingPresenterTests.swift
//  HotelsDemoTests
//
//  Created by Denys Kotenko on 31/7/25.
//

import XCTest
import HotelsDemo

final class StarRatingPresenterTests: XCTestCase {
	func test_present_displaysStarRatingOptions() {
		let (sut, viewController) = makeSUT()

		sut.present(response: .init(options: [oneStarOption()]))
		XCTAssertEqual(viewController.messages.last, .display(.init(options: [oneStarOptionViewModel()])))

		sut.present(response: .init(options: [fiveStarOption(isSelected: true)]))
		XCTAssertEqual(viewController.messages.last, .display(.init(options: [fiveStarOptionViewModel(isSelected: true)])))
	}

	func test_presentReset_displaysStarRatingOptions() {
		let (sut, viewController) = makeSUT()

		sut.presentReset(response: .init(options: [oneStarOption()]))
		XCTAssertEqual(viewController.messages.last, .displayReset(.init(options: [oneStarOptionViewModel()])))

		sut.presentReset(response: .init(options: [fiveStarOption()]))
		XCTAssertEqual(viewController.messages.last, .displayReset(.init(options: [fiveStarOptionViewModel()])))
	}

	func test_presentSelect_displaysSelectedStarRatings() {
		let (sut, viewController) = makeSUT()

		sut.presentSelect(response: .init(starRatings: [], options: [oneStarOption()]))
		XCTAssertEqual(viewController.messages.last, .displaySelect(.init(starRatings: [], options: [oneStarOptionViewModel()])))

		sut.presentSelect(response: .init(starRatings: [.one], options: [oneStarOption(isSelected: true)]))
		XCTAssertEqual(viewController.messages.last, .displaySelect(.init(starRatings: [.one], options: [oneStarOptionViewModel(isSelected: true)])))
	}

	// MARK: - Helpers

	private func makeSUT() -> (
		sut: StarRatingPresenter,
		viewController: StarRatingDisplayLogicSpy
	) {
		let viewController = StarRatingDisplayLogicSpy()
		let sut = StarRatingPresenter()
		sut.viewController = viewController
		return (sut, viewController)
	}
}

final class StarRatingDisplayLogicSpy: StarRatingDisplayLogic {
	enum Message: Equatable {
		case display(StarRatingModels.Load.ViewModel)
		case displayReset(StarRatingModels.Reset.ViewModel)
		case displaySelect(StarRatingModels.Select.ViewModel)
	}

	private(set) var messages = [Message]()

	func display(viewModel: StarRatingModels.Load.ViewModel) {
		messages.append(.display(viewModel))
	}
	
	func displayReset(viewModel: StarRatingModels.Reset.ViewModel) {
		messages.append(.displayReset(viewModel))
	}
	
	func displaySelect(viewModel: StarRatingModels.Select.ViewModel) {
		messages.append(.displaySelect(viewModel))
	}
}

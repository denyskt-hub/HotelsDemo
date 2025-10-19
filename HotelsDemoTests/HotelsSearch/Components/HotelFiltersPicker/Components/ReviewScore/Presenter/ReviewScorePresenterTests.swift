//
//  ReviewScorePresenterTests.swift
//  HotelsDemoTests
//
//  Created by Denys Kotenko on 30/7/25.
//

import XCTest
import HotelsDemo

final class ReviewScorePresenterTests: XCTestCase {
	func test_present_displaysReviewScoreOptions() {
		let (sut, viewController) = makeSUT()

		sut.present(response: .init(options: [fairOption()]))
		XCTAssertEqual(viewController.messages.last, .display(.init(options: [fairOptionViewModel()])))

		sut.present(response: .init(options: [wonderfulOption(isSelected: true)]))
		XCTAssertEqual(viewController.messages.last, .display(.init(options: [wonderfulOptionViewModel(isSelected: true)])))
	}

	func test_presentReset_displaysReviewScoreOptions() {
		let (sut, viewController) = makeSUT()

		sut.presentReset(response: .init(options: [fairOption()]))
		XCTAssertEqual(viewController.messages.last, .displayReset(.init(options: [fairOptionViewModel()])))

		sut.presentReset(response: .init(options: [wonderfulOption()]))
		XCTAssertEqual(viewController.messages.last, .displayReset(.init(options: [wonderfulOptionViewModel()])))
	}

	func test_presentSelect_displaysSelectedReviewScore() {
		let (sut, viewController) = makeSUT()

		sut.presentSelect(response: .init(reviewScore: nil, options: [fairOption()]))
		XCTAssertEqual(viewController.messages.last, .displaySelect(.init(reviewScore: nil, options: [fairOptionViewModel()])))

		sut.presentSelect(response: .init(reviewScore: .fair, options: [fairOption(isSelected: true)]))
		XCTAssertEqual(viewController.messages.last, .displaySelect(.init(reviewScore: .fair, options: [fairOptionViewModel(isSelected: true)])))
	}

	// MARK: - Helpers

	private func makeSUT() -> (
		sut: ReviewScorePresenter,
		viewController: ReviewScoreDisplayLogicSpy
	) {
		let viewController = ReviewScoreDisplayLogicSpy()
		let sut = ReviewScorePresenter(
			viewController: viewController
		)
		return (sut, viewController)
	}
}

final class ReviewScoreDisplayLogicSpy: ReviewScoreDisplayLogic {
	enum Message: Equatable {
		case display(ReviewScoreModels.FetchReviewScore.ViewModel)
		case displayReset(ReviewScoreModels.ReviewScoreReset.ViewModel)
		case displaySelect(ReviewScoreModels.ReviewScoreSelection.ViewModel)
	}

	private(set) var messages = [Message]()

	func display(viewModel: ReviewScoreModels.FetchReviewScore.ViewModel) {
		messages.append(.display(viewModel))
	}

	func displayReset(viewModel: ReviewScoreModels.ReviewScoreReset.ViewModel) {
		messages.append(.displayReset(viewModel))
	}

	func displaySelect(viewModel: ReviewScoreModels.ReviewScoreSelection.ViewModel) {
		messages.append(.displaySelect(viewModel))
	}
}

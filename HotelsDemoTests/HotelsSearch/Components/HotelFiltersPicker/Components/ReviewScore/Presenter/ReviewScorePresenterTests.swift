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
		let sut = ReviewScorePresenter()
		sut.viewController = viewController
		return (sut, viewController)
	}

	private func fairOption(isSelected: Bool = false) -> ReviewScoreModels.Option {
		makeOption(.fair, isSelected: isSelected)
	}

	private func fairOptionViewModel(isSelected: Bool = false) -> ReviewScoreModels.OptionViewModel {
		.init(title: ReviewScore.fair.title, value: .fair, isSelected: isSelected)
	}

	private func wonderfulOption(isSelected: Bool = false) -> ReviewScoreModels.Option {
		makeOption(.wonderful, isSelected: isSelected)
	}

	private func wonderfulOptionViewModel(isSelected: Bool = false) -> ReviewScoreModels.OptionViewModel {
		.init(title: ReviewScore.wonderful.title, value: .wonderful, isSelected: isSelected)
	}

	private func makeOption(_ reviewScore: ReviewScore, isSelected: Bool) -> ReviewScoreModels.Option {
		.init(value: reviewScore, isSelected: isSelected)
	}

	private func makeOptionViewModel(_ reviewScore: ReviewScore, isSelected: Bool = false) -> ReviewScoreModels.OptionViewModel {
		.init(title: reviewScore.title, value: reviewScore, isSelected: isSelected)
	}
}

final class ReviewScoreDisplayLogicSpy: ReviewScoreDisplayLogic {
	enum Message: Equatable {
		case display(ReviewScoreModels.Load.ViewModel)
		case displayReset(ReviewScoreModels.Reset.ViewModel)
		case displaySelect(ReviewScoreModels.Select.ViewModel)
	}

	private(set) var messages = [Message]()

	func display(viewModel: ReviewScoreModels.Load.ViewModel) {
		messages.append(.display(viewModel))
	}

	func displayReset(viewModel: ReviewScoreModels.Reset.ViewModel) {
		messages.append(.displayReset(viewModel))
	}

	func displaySelect(viewModel: ReviewScoreModels.Select.ViewModel) {
		messages.append(.displaySelect(viewModel))
	}
}

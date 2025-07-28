//
//  ReviewScoreInteractorTests.swift
//  HotelsDemoTests
//
//  Created by Denys Kotenko on 28/7/25.
//

import XCTest
import HotelsDemo

final class ReviewScoreInteractorTests: XCTestCase {
	func test_load_presentsInitialState() {
		let (sut, presenter) = makeSUT()
		
		sut.load(request: .init())
		
		XCTAssertEqual(presenter.messages, [
			.present(.init(options: [
				.init(value: .fair, isSelected: false),
				.init(value: .pleasant, isSelected: false),
				.init(value: .good, isSelected: false),
				.init(value: .veryGood, isSelected: false),
				.init(value: .wonderful, isSelected: false)
			]))
		])
	}

	// MARK: - Helpers

	private func makeSUT(selectedReviewScore: ReviewScore? = nil) -> (
		sut: ReviewScoreInteractor,
		presenter: ReviewScorePresentationLogicSpy
	) {
		let presenter = ReviewScorePresentationLogicSpy()
		let sut = ReviewScoreInteractor(
			selectedReviewScore: selectedReviewScore
		)
		sut.presenter = presenter
		return (sut, presenter)
	}
}

final class ReviewScorePresentationLogicSpy: ReviewScorePresentationLogic {
	enum Message: Equatable {
		case present(ReviewScoreModels.Load.Response)
		case presentReset(ReviewScoreModels.Reset.Response)
		case presentSelect(ReviewScoreModels.Select.Response)
	}

	private(set) var messages = [Message]()

	func present(response: ReviewScoreModels.Load.Response) {
		messages.append(.present(response))
	}
	
	func presentReset(response: ReviewScoreModels.Reset.Response) {
		messages.append(.presentReset(response))
	}
	
	func presentSelect(response: ReviewScoreModels.Select.Response) {
		messages.append(.presentSelect(response))
	}
}

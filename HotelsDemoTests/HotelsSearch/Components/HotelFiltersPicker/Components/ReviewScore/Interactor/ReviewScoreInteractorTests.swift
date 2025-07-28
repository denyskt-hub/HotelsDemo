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
		let cases: [(ReviewScore?, String)] = [
			(nil, "when nothing selected"),
			(.fair, "when .fair is selected"),
			(.wonderful, "when .wonderful is selected")
		]

		cases.forEach { selected, description in
			let (sut, presenter) = makeSUT(selectedReviewScore: selected)

			sut.load(request: .init())

			let expectedOptions = ReviewScoreModels.Option.makeAll(selected: selected)
			XCTAssertEqual(presenter.messages.last, .present(.init(options: expectedOptions)), description)
		}
	}

	func test_reset_presentsReset() {
		let (sut, presenter) = makeSUT(selectedReviewScore: .pleasant)

		sut.reset(request: .init())

		let expectedOptions = ReviewScoreModels.Option.makeAll(selected: nil)
		XCTAssertEqual(presenter.messages, [.presentReset(.init(options: expectedOptions))])
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

	private func makeOptions(_ selectedReviewScore: ReviewScore?) -> [ReviewScoreModels.Option] {
		ReviewScore.allCases.map {
			ReviewScoreModels.Option(value: $0, isSelected: $0 == selectedReviewScore)
		}
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

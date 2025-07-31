//
//  ReviewScoreViewControllerTests.swift
//  HotelsDemoTests
//
//  Created by Denys Kotenko on 30/7/25.
//

import XCTest
import HotelsDemo

final class ReviewScoreViewControllerTests: XCTestCase {
	private let options = [fairOptionViewModel(), wonderfulOptionViewModel()]
	private let optionsWithSelectedOption = [fairOptionViewModel(), wonderfulOptionViewModel(isSelected: true)]

	func test_viewDidLoad_loadsInitialData() {
		let (sut, interactor, _) = makeSUT()

		sut.simulateAppearance()

		XCTAssertEqual(interactor.messages, [.load(.init())])
	}

	func test_display_rendersReviewScoreOptions() {
		let (sut, _, _) = makeSUT()
		sut.simulateAppearanceInWindow()

		sut.display(viewModel: .init(options: options))
		assertThat(sut, isRendering: options)

		sut.display(viewModel: .init(options: optionsWithSelectedOption))
		assertThat(sut, isRendering: optionsWithSelectedOption)
	}

	func test_displayReset_rendersReviewScoreOptions() {
		let (sut, _, _) = makeSUT()
		sut.simulateAppearanceInWindow()

		sut.displayReset(viewModel: .init(options: options))

		assertThat(sut, isRendering: options)
	}

	func test_displaySelect_rendersReviewScoreOptions() {
		let (sut, _, _) = makeSUT()
		sut.simulateAppearanceInWindow()

		sut.displaySelect(viewModel: .init(reviewScore: .fair, options: options))

		assertThat(sut, isRendering: options)
	}

	func test_displaySelect_notifiesDelegateWithSelectedReviewScore() {
		let (sut, _, delegate) = makeSUT()

		sut.displaySelect(viewModel: .init(reviewScore: .fair, options: options))

		XCTAssertEqual(delegate.messages, [.didSelectReviewScore(.fair)])
	}

	// MARK: - Helpers

	private func makeSUT() -> (
		sut: ReviewScoreViewController,
		interactor: ReviewScoreBusinessLogicSpy,
		delegate: ReviewScoreDelegateSpy
	) {
		let interactor = ReviewScoreBusinessLogicSpy()
		let delegate = ReviewScoreDelegateSpy()
		let sut = ReviewScoreViewController()
		sut.interactor = interactor
		sut.delegate = delegate
		return (sut, interactor, delegate)
	}

	private func assertThat(
		_ sut: ReviewScoreViewController,
		isRendering viewModels: [ReviewScoreModels.OptionViewModel],
		file: StaticString = #filePath,
		line: UInt = #line
	) {
		guard sut.numberOfRenderedOptions() == viewModels.count else {
			return XCTFail("Expect \(viewModels.count) options, got \(sut.numberOfRenderedOptions()) instead", file: file, line: line)
		}

		viewModels.enumerated().forEach { index, viewModel in
			assertThat(sut, hasViewConfiguredFor: viewModel, at: index, file: file, line: line)
		}
	}

	private func assertThat(
		_ sut: ReviewScoreViewController,
		hasViewConfiguredFor viewModel: ReviewScoreModels.OptionViewModel,
		at index: Int,
		file: StaticString = #filePath,
		line: UInt = #line
	) {
		let view = sut.optionView(at: index)

		guard let cell = view as? ReviewScoreCell else {
			return XCTFail("Expected \(ReviewScoreCell.self) instance, got \(String(describing: view)) instead", file: file, line: line)
		}

		XCTAssertEqual(cell.titleLabel.text, viewModel.title, "Expected titleLabel to be \(viewModel.title), for view at index \(index)", file: file, line: line)
		XCTAssertEqual(cell.checkmarkImageView.isHighlighted, viewModel.isSelected, "Expected checkmarkImageView.isHighlighted to be \(viewModel.isSelected), for view at index \(index)", file: file, line: line)
	}
}

final class ReviewScoreBusinessLogicSpy: ReviewScoreBusinessLogic {
	enum Message: Equatable {
		case load(ReviewScoreModels.Load.Request)
		case reset(ReviewScoreModels.Reset.Request)
		case select(ReviewScoreModels.Select.Request)
	}

	private(set) var messages = [Message]()

	func load(request: ReviewScoreModels.Load.Request) {
		messages.append(.load(request))
	}
	
	func reset(request: ReviewScoreModels.Reset.Request) {
		messages.append(.reset(request))
	}
	
	func select(request: ReviewScoreModels.Select.Request) {
		messages.append(.select(request))
	}
}

final class ReviewScoreDelegateSpy: ReviewScoreDelegate {
	enum Message: Equatable {
		case didSelectReviewScore(ReviewScore?)
	}

	private(set) var messages = [Message]()

	func didSelectReviewScore(_ reviewScore: ReviewScore?) {
		messages.append(.didSelectReviewScore(reviewScore))
	}
}

extension ReviewScoreViewController {
	func numberOfRenderedOptions() -> Int {
		numberOfRows(in: 0)
	}

	func optionView(at index: Int) -> UITableViewCell? {
		cell(row: index, section: 0)
	}

	private func cell(row: Int, section: Int) -> UITableViewCell? {
		guard numberOfRows(in: section) > row else { return nil }

		let dataSource = tableView.dataSource
		let indexPath = IndexPath(row: row, section: section)
		return dataSource?.tableView(tableView, cellForRowAt: indexPath)
	}

	private func numberOfRows(in section: Int) -> Int {
		tableView.numberOfSections == 0 ? 0 : tableView.numberOfSections > section ? tableView.numberOfRows(inSection: section) : 0
	}
}

//
//  StarRatingViewControllerTests.swift
//  HotelsDemoTests
//
//  Created by Denys Kotenko on 31/7/25.
//

import XCTest
import HotelsDemo

final class StarRatingViewControllerTests: XCTestCase, ListItemsRendererTestCase {
	private let options = [oneStarOptionViewModel(), fiveStarOptionViewModel()]
	private let optionsWithSelectedOption = [oneStarOptionViewModel(), fiveStarOptionViewModel(isSelected: true)]

	func test_viewDidLoad_loadsInitialData() {
		let (sut, interactor, _) = makeSUT()

		sut.simulateAppearance()

		XCTAssertEqual(interactor.messages, [.doFetchStarRating(.init())])
	}

	func test_reset_resetsSelectedOptions() {
		let (sut, interactor, _) = makeSUT()

		sut.reset()

		XCTAssertEqual(interactor.messages, [.handleStarRatingReset(.init())])
	}

	func test_tapOnOption_selectsOptions() {
		let (sut, interactor, _) = makeSUT()
		sut.simulateAppearanceInWindow()
		sut.display(viewModel: .init(options: [makeOptionViewModel(.five)]))

		sut.simulateTapOnItem(at: 0)

		XCTAssertEqual(interactor.messages.last, .handleStarRatingSelection(.init(starRating: .five)))
	}

	func test_display_rendersStarRatingOptions() {
		let (sut, _, _) = makeSUT()
		sut.simulateAppearanceInWindow()

		sut.display(viewModel: .init(options: options))
		assertThat(sut, isRendering: options)

		sut.display(viewModel: .init(options: optionsWithSelectedOption))
		assertThat(sut, isRendering: optionsWithSelectedOption)
	}

	func test_displayReset_rendersStarRatingOptions() {
		let (sut, _, _) = makeSUT()
		sut.simulateAppearanceInWindow()

		sut.displayReset(viewModel: .init(options: options))

		assertThat(sut, isRendering: options)
	}

	func test_displaySelect_rendersStarRatingOptions() {
		let (sut, _, _) = makeSUT()
		sut.simulateAppearanceInWindow()

		sut.displaySelect(viewModel: .init(starRatings: [.five], options: options))

		assertThat(sut, isRendering: options)
	}

	func test_displaySelect_notifiesDelegateWithSelectedStarRatings() {
		let (sut, _, delegate) = makeSUT()

		sut.displaySelect(viewModel: .init(starRatings: [.five], options: options))

		XCTAssertEqual(delegate.messages, [.didSelectStarRatings([.five])])
	}

	// MARK: - Helpers

	private func makeSUT() -> (
		sut: StarRatingViewController,
		interactor: StarRatingBusinessLogicSpy,
		delegate: StarRatingDelegateSpy
	) {
		let interactor = StarRatingBusinessLogicSpy()
		let delegate = StarRatingDelegateSpy()
		let sut = StarRatingViewController(
			interactor: interactor,
			delegate: delegate
		)
		return (sut, interactor, delegate)
	}

	private func assertThat(
		_ sut: StarRatingViewController,
		isRendering viewModels: [StarRatingModels.OptionViewModel],
		file: StaticString = #filePath,
		line: UInt = #line
	) {
		assertThat(sut, isRendering: viewModels, assert: { view, viewModel, index in
			guard let cell = view as? StarRatingCell else {
				return XCTFail("Expected \(StarRatingCell.self) instance, got \(String(describing: view)) instead", file: file, line: line)
			}

			XCTAssertEqual(cell.starRatingView.rating, viewModel.value.rawValue, "Expected starRatingView.rating to be \(viewModel.value), for view at index \(index)", file: file, line: line)
			XCTAssertEqual(cell.checkmarkImageView.isHighlighted, viewModel.isSelected, "Expected checkmarkImageView.isHighlighted to be \(viewModel.isSelected), for view at index \(index)", file: file, line: line)
		}, file: file, line: line)
	}
}

final class StarRatingBusinessLogicSpy: StarRatingBusinessLogic {
	enum Message: Equatable {
		case doFetchStarRating(StarRatingModels.FetchStarRating.Request)
		case handleStarRatingReset(StarRatingModels.StarRatingReset.Request)
		case handleStarRatingSelection(StarRatingModels.StarRatingSelection.Request)
	}

	private(set) var messages = [Message]()

	func doFetchStarRating(request: StarRatingModels.FetchStarRating.Request) {
		messages.append(.doFetchStarRating(request))
	}

	func handleStarRatingReset(request: StarRatingModels.StarRatingReset.Request) {
		messages.append(.handleStarRatingReset(request))
	}

	func handleStarRatingSelection(request: StarRatingModels.StarRatingSelection.Request) {
		messages.append(.handleStarRatingSelection(request))
	}
}

final class StarRatingDelegateSpy: StarRatingDelegate {
	enum Message: Equatable {
		case didSelectStarRatings(Set<StarRating>)
	}

	private(set) var messages = [Message]()

	func didSelectStarRatings(_ starRatings: Set<StarRating>) {
		messages.append(.didSelectStarRatings(starRatings))
	}
}

extension StarRatingViewController: TableViewRenderer {}

//
//  DestinationPickerViewControllerTests.swift
//  HotelsDemoTests
//
//  Created by Denys Kotenko on 8/7/25.
//

import XCTest
import HotelsDemo

final class DestinationPickerViewControllerTests: XCTestCase, ListItemsRendererTestCase {
	func test_viewDidLoad_doesNotRequestSearchDestinations() {
		let (sut, interactor, _) = makeSUT()

		sut.simulateAppearance()

		XCTAssertTrue(interactor.messages.isEmpty)
	}

	func test_search_requestsDestinationsFromInteractor() {
		let (sut, interactor, _) = makeSUT()
		sut.simulateAppearance()

		sut.simulateSearch("first query")
		XCTAssertEqual(interactor.messages, [.doSearchDestinations(.init(query: "first query"))])

		sut.simulateSearch("second query")
		XCTAssertEqual(interactor.messages, [
			.doSearchDestinations(.init(query: "first query")),
			.doSearchDestinations(.init(query: "second query"))
		])
	}

	func test_displayDestinations_rendersDestinations() {
		let destinations: [DestinationPickerModels.Search.DestinationViewModel] = [
			.init(title: "London", subtitle: "United Kingdom")
		]
		let (sut, _, _) = makeSUT()

		sut.simulateAppearanceInWindow()
		assertThat(sut, isRendering: [])

		sut.displayDestinations(viewModel: .init(destinations: destinations))
		assertThat(sut, isRendering: destinations)
	}

	func test_destinationCellDidTap_selectsDestination() {
		let (sut, interactor, _) = makeSUT()
		sut.simulateAppearanceInWindow()
		sut.displayDestinations(
			viewModel: .init(destinations: [.init(title: "London", subtitle: "United Kingdom")])
		)

		sut.simulateTapOnDestination(at: 0)

		XCTAssertEqual(interactor.messages, [.handleDestinationSelection(.init(index: 0))])
	}

	func test_displaySelectedDestination_notifiesDelegateWithSelectedDestination() {
		let destination = anyDestination()
		let (sut, _, delegate) = makeSUT()

		sut.displaySelectedDestination(viewModel: .init(selected: destination))

		XCTAssertEqual(delegate.messages, [.didSelectDestination(destination)])
	}

	func test_displaySearchError_rendersErrorMessage() {
		let errorMessage = "Some error message"
		let (sut, _, _) = makeSUT()

		sut.displaySearchError(viewModel: .init(message: errorMessage))

		XCTAssertEqual(sut.errorLabel.text, errorMessage)
	}

	func test_hideSearchError_rendersNoErrorMessage() {
		let (sut, _, _) = makeSUT()
		sut.displaySearchError(viewModel: .init(message: "any error message"))

		sut.hideSearchError()

		XCTAssertNil(sut.errorLabel.text)
	}

	// MARK: - Helpers

	private func makeSUT() -> (
		sut: DestinationPickerViewController,
		interactor: DestinationPickerBusinessLogicSpy,
		delegate: DestinationPickerDelegateSpy
	) {
		let interactor = DestinationPickerBusinessLogicSpy()
		let delegate = DestinationPickerDelegateSpy()
		let sut = DestinationPickerViewController()
		sut.interactor = interactor
		sut.delegate = delegate
		return (sut, interactor, delegate)
	}

	private func assertThat(
		_ sut: DestinationPickerViewController,
		isRendering destinations: [DestinationPickerModels.Search.DestinationViewModel],
		file: StaticString = #filePath,
		line: UInt = #line
	) {
		assertThat(sut, isRendering: destinations, assert: { view, viewModel, index in
			guard let cell = view as? DestinationCell else {
				return XCTFail("Expected \(DestinationCell.self) instance, got \(String(describing: view)) instead", file: file, line: line)
			}

			XCTAssertEqual(cell.titleLabel.text, viewModel.title, "Expected titleLabel to be \(viewModel.title), for destination view at index (\(index))", file: file, line: line)

			XCTAssertEqual(cell.subtitleLabel.text, viewModel.subtitle, "Expected subtitleLabel to be \(viewModel.subtitle), for destination view at index (\(index))", file: file, line: line)
		}, file: file, line: line)
	}
}

extension DestinationPickerViewController: TableViewRenderer {
	func simulateSearch(_ query: String) {
		let currentText = textField.text ?? ""
		let range = NSRange(location: 0, length: currentText.count)
		let shouldChange = textField.delegate?.textField?(
			textField,
			shouldChangeCharactersIn: range,
			replacementString: query
		) ?? true

		if shouldChange {
			textField.text = query
		}
	}

	func simulateTapOnDestination(at row: Int) {
		let delegate = tableView.delegate
		let indexPath = IndexPath(row: row, section: 0)
		delegate?.tableView?(tableView, didSelectRowAt: indexPath)
	}
}

final class DestinationPickerBusinessLogicSpy: DestinationPickerBusinessLogic {
	enum Message: Equatable {
		case doSearchDestinations(DestinationPickerModels.Search.Request)
		case handleDestinationSelection(DestinationPickerModels.DestinationSelection.Request)
	}

	private(set) var messages = [Message]()

	func doSearchDestinations(request: DestinationPickerModels.Search.Request) {
		messages.append(.doSearchDestinations(request))
	}
	
	func handleDestinationSelection(request: DestinationPickerModels.DestinationSelection.Request) {
		messages.append(.handleDestinationSelection(request))
	}
}

final class DestinationPickerDelegateSpy: DestinationPickerDelegate {
	enum Message: Equatable {
		case didSelectDestination(Destination)
	}

	private(set) var messages = [Message]()

	func didSelectDestination(_ destination: Destination) {
		messages.append(.didSelectDestination(destination))
	}
}

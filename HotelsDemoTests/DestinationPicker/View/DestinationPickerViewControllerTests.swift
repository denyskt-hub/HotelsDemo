//
//  DestinationPickerViewControllerTests.swift
//  HotelsDemoTests
//
//  Created by Denys Kotenko on 8/7/25.
//

import XCTest
import HotelsDemo

final class DestinationPickerViewControllerTests: XCTestCase {
	func test_viewDidLoad_doesNotRequestSearchDestinations() {
		let (sut, interactor, _) = makeSUT()

		sut.simulateAppearance()

		XCTAssertTrue(interactor.messages.isEmpty)
	}

	func test_search_requestsDestinationsFromInteractor() {
		let (sut, interactor, _) = makeSUT()
		sut.simulateAppearance()

		sut.simulateSearch("first query")
		XCTAssertEqual(interactor.messages, [.searchDestinations(.init(query: "first query"))])

		sut.simulateSearch("second query")
		XCTAssertEqual(interactor.messages, [
			.searchDestinations(.init(query: "first query")),
			.searchDestinations(.init(query: "second query"))
		])
	}

	func test_displayDestinations_rendersDestinations() {
		let destinations = ["London", "Boston"]
		let (sut, _, _) = makeSUT()

		sut.simulateAppearanceInWindow()
		assertThat(sut, isRendering: [])

		sut.displayDestinations(viewModel: .init(destinations: destinations))
		assertThat(sut, isRendering: destinations)
	}

	func test_destinationCellDidTap_selectsDestination() {
		let (sut, interactor, _) = makeSUT()
		sut.simulateAppearanceInWindow()
		sut.displayDestinations(viewModel: .init(destinations: ["London"]))

		sut.simulateTapOnDestination(at: 0)

		XCTAssertEqual(interactor.messages, [.selectDestination(.init(index: 0))])
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
		isRendering destinations: [String],
		file: StaticString = #filePath,
		line: UInt = #line
	) {
		guard sut.numberOfRenderedDestinationViews() == destinations.count else {
			return XCTFail("Expect \(destinations.count) images, got \(sut.numberOfRenderedDestinationViews()) instead", file: file, line: line)
		}

		destinations.enumerated().forEach { index, destination in
			assertThat(sut, hasViewConfiguredFor: destination, at: index, file: file, line: line)
		}
	}

	private func assertThat(
		_ sut: DestinationPickerViewController,
		hasViewConfiguredFor destination: String,
		at index: Int,
		file: StaticString = #filePath,
		line: UInt = #line
	) {
		let view = sut.destinationView(at: index)

		guard let cell = view as? DestinationCell else {
			return XCTFail("Expected \(DestinationCell.self) instance, got \(String(describing: view)) instead", file: file, line: line)
		}

		XCTAssertEqual(cell.label.text, destination, "Expected label to be \(destination), for destination view at index (\(index))", file: file, line: line)
	}
}

extension DestinationPickerViewController {
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

	func numberOfRenderedDestinationViews() -> Int {
		numberOfRows(in: 0)
	}

	func destinationView(at index: Int) -> UITableViewCell? {
		cell(row: index, section: 0)
	}

	func simulateTapOnDestination(at row: Int) {
		let delegate = tableView.delegate
		let indexPath = IndexPath(row: row, section: 0)
		delegate?.tableView?(tableView, didSelectRowAt: indexPath)
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

final class DestinationPickerBusinessLogicSpy: DestinationPickerBusinessLogic {
	enum Message: Equatable {
		case searchDestinations(DestinationPickerModels.Search.Request)
		case selectDestination(DestinationPickerModels.Select.Request)
	}

	private(set) var messages = [Message]()

	func searchDestinations(request: DestinationPickerModels.Search.Request) {
		messages.append(.searchDestinations(request))
	}
	
	func selectDestination(request: DestinationPickerModels.Select.Request) {
		messages.append(.selectDestination(request))
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

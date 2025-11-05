//
//  DestinationPickerInteractorTests.swift
//  HotelsDemoTests
//
//  Created by Denys Kotenko on 28/6/25.
//

import XCTest
import HotelsDemo

@MainActor
final class DestinationPickerInteractorTests: XCTestCase {
	func test_init_doesNotMessageService() {
		let (_, service, _) = makeSUT()

		XCTAssertTrue(service.queries.isEmpty)
	}

	func test_doSearchDestinations_presentSearchErrorOnServiceError() async {
		let serviceError = anyNSError()
		let (sut, service, presenter) = makeSUT()

		sut.doSearchDestinations(request: .init(query: "any"))

		await service.waitUntilStarted()
		service.completeWithResult(.failure(serviceError))

		await presenter.waitUntilPresented()
		XCTAssertEqual(presenter.messages, [.presentSearchError(serviceError)])
	}

	func test_doSearchDestinations_presentDestinationsOnServiceSuccess() async {
		let destinations = [anyDestination()]
		let (sut, service, presenter) = makeSUT()

		sut.doSearchDestinations(request: .init(query: "any"))

		await service.waitUntilStarted()
		service.completeWithResult(.success(destinations))

		await presenter.waitUntilPresented()
		XCTAssertEqual(presenter.messages, [.presentDestinations(.init(destinations: destinations))])
	}

	func test_doSearchDestinations_doesNotMessageServiceOnEmptyQuery() {
		let (sut, service, _) = makeSUT()

		sut.doSearchDestinations(request: .init(query: ""))
		XCTAssertTrue(service.queries.isEmpty)

		sut.doSearchDestinations(request: .init(query: "  "))
		XCTAssertTrue(service.queries.isEmpty)
	}

	func test_doSearchDestinations_presentEmptyDestinationsOnEmptyQuery() async {
		let (sut, _, presenter) = makeSUT()

		sut.doSearchDestinations(request: .init(query: ""))
		await presenter.waitUntilPresented()
		XCTAssertEqual(presenter.messages, [.presentDestinations(.init(destinations: []))])

		sut.doSearchDestinations(request: .init(query: "  "))
		await presenter.waitUntilPresented()
		XCTAssertEqual(presenter.messages, [
			.presentDestinations(.init(destinations: [])),
			.presentDestinations(.init(destinations: []))
		])
	}

	func test_handleDestinationSelection_presentSelectedDestination() async {
		let destination = anyDestination()
		let (sut, service, presenter) = makeSUT()
		sut.doSearchDestinations(request: .init(query: "any"))

		await service.waitUntilStarted()
		service.completeWithResult(.success([destination]))

		await presenter.waitUntilPresented()
		XCTAssertEqual(presenter.messages, [.presentDestinations(.init(destinations: [destination]))])

		sut.handleDestinationSelection(request: .init(index: 0))
		await presenter.waitUntilPresented()

		XCTAssertEqual(presenter.messages.last, .presentSelectedDestination(.init(selected: destination)))
	}

	// MARK: - Helpers

	private func makeSUT() -> (
		sut: DestinationPickerInteractor,
		service: DestinationSearchServiceSpy,
		presenter: DestinationPickerPresenterSpy
	) {
		let service = DestinationSearchServiceSpy()
		let presenter = DestinationPickerPresenterSpy()
		let sut = DestinationPickerInteractor(
			worker: service,
			presenter: presenter
		)
		return (sut, service, presenter)
	}
}

final class DestinationSearchServiceSpy: DestinationSearchService {
	private(set) var queries = [String]()

	private var continuations = [CheckedContinuation<[Destination], Error>]()

	private let stream = AsyncStream<Void>.makeStream()

	func search(query: String, completion: @escaping (DestinationSearchService.Result) -> Void) {
		// probably never called anymore
		fatalError("don’t use callback API in tests")
	}

	func search(query: String) async throws -> [Destination] {
		queries.append(query)
		stream.continuation.yield(())

		return try await withCheckedThrowingContinuation { continuation in
			continuations.append(continuation)
		}
	}

	func completeWithResult(_ result: DestinationSearchService.Result, at index: Int = 0) {
		switch result {
		case let .success(destinations):
			continuations[index].resume(returning: destinations)
		case let .failure(error):
			continuations[index].resume(throwing: error)
		}
	}

	func waitUntilStarted() async {
		var iterator = stream.stream.makeAsyncIterator()
		_ = await iterator.next()
	}
}

final class DestinationPickerPresenterSpy: DestinationPickerPresentationLogic {
	enum Message: Equatable {
		case presentDestinations(DestinationPickerModels.Search.Response)
		case presentSelectedDestination(DestinationPickerModels.DestinationSelection.Response)
		case presentSearchError(NSError)
	}

	private(set) var messages = [Message]()

	private let stream = AsyncStream<Void>.makeStream()

	func presentDestinations(response: DestinationPickerModels.Search.Response) {
		messages.append(.presentDestinations(response))
		stream.continuation.yield(())
	}

	func presentSelectedDestination(response: DestinationPickerModels.DestinationSelection.Response) {
		messages.append(.presentSelectedDestination(response))
		stream.continuation.yield(())
	}

	func presentSearchError(_ error: Error) {
		messages.append(.presentSearchError(error as NSError))
		stream.continuation.yield(())
	}

	func waitUntilPresented() async {
		var iterator = stream.stream.makeAsyncIterator()
		_ = await iterator.next()
	}
}

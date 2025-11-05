//
//  DestinationPickerInteractorTests.swift
//  HotelsDemoTests
//
//  Created by Denys Kotenko on 28/6/25.
//

import XCTest
import HotelsDemo
import Synchronization

@MainActor
final class DestinationPickerInteractorTests: XCTestCase {
	func test_init_doesNotMessageService() {
		let (_, service, _) = makeSUT()

		XCTAssertTrue(service.receivedQueries().isEmpty)
	}

	func test_doSearchDestinations_presentSearchErrorOnServiceError() async {
		let serviceError = anyNSError()
		let (sut, service, presenter) = makeSUT()

		sut.doSearchDestinations(request: .init(query: "any"))

		await service.waitUntilStarted()
		service.completeWithError(serviceError)

		await presenter.waitUntilPresented()
		XCTAssertEqual(presenter.messages, [.presentSearchError(serviceError)])
	}

	func test_doSearchDestinations_presentDestinationsOnServiceSuccess() async {
		let destinations = [anyDestination()]
		let (sut, service, presenter) = makeSUT()

		sut.doSearchDestinations(request: .init(query: "any"))

		await service.waitUntilStarted()
		service.completeWithDestinations(destinations)

		await presenter.waitUntilPresented()
		XCTAssertEqual(presenter.messages, [.presentDestinations(.init(destinations: destinations))])
	}

	func test_doSearchDestinations_trimsQueryBeforeSendingToService() async {
		let (sut, service, _) = makeSUT()

		sut.doSearchDestinations(request: .init(query: "  Rome  "))
		await service.waitUntilStarted()

		XCTAssertEqual(service.receivedQueries(), ["Rome"])
	}

	func test_doSearchDestinations_doesNotMessageServiceOnEmptyQuery() {
		let (sut, service, _) = makeSUT()

		sut.doSearchDestinations(request: .init(query: ""))
		XCTAssertTrue(service.receivedQueries().isEmpty)

		sut.doSearchDestinations(request: .init(query: "  "))
		XCTAssertTrue(service.receivedQueries().isEmpty)
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
		service.completeWithDestinations([destination])

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
	private let queries = Mutex<[String]>([])
	private let continuations = Mutex<[CheckedContinuation<[Destination], Error>]>([])

	private let stream = AsyncStream<Void>.makeStream()

	func receivedQueries() -> [String] {
		queries.withLock { $0 }
	}

	func search(query: String) async throws -> [Destination] {
		queries.withLock { $0.append(query) }
		stream.continuation.yield(())

		return try await withCheckedThrowingContinuation { continuation in
			continuations.withLock { $0.append(continuation) }
		}
	}

	func completeWithDestinations(_ destinations: [Destination], at index: Int = 0) {
		let continuation = continuations.withLock { $0[index] }
		continuation.resume(returning: destinations)
	}

	func completeWithError(_ error: Error, at index: Int = 0) {
		let continuation = continuations.withLock { $0[index] }
		continuation.resume(throwing: error)
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

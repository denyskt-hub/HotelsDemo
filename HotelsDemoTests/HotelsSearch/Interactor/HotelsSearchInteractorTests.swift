//
//  HotelsSearchInteractorTests.swift
//  HotelsDemoTests
//
//  Created by Denys Kotenko on 17/7/25.
//

import XCTest
import HotelsDemo
import Synchronization

@MainActor
final class HotelsSearchInteractorTests: XCTestCase {
	func test_init_doesNotRequestSearch() {
		let (_, service, _) = makeSUT()

		XCTAssertTrue(service.receivedMessages().isEmpty)
	}

	func test_search_requestsSearchWithCorrectCriteria() async {
		let criteria = anySearchCriteria()
		let (sut, service, presenter) = makeSUT(criteria: criteria)

		sut.handleViewDidAppear(request: .init())
		await service.waitUntilStarted()

		XCTAssertEqual(service.receivedMessages(), [.search(criteria)])

		// Drain the in-flight request so no suspended task outlives the test.
		service.completeWithHotels([])
		await presenter.waitUntilPresented(expected: 3)
	}

	func test_search_presentsErrorOnServiceError() async {
		let serviceError = anyNSError()
		let (sut, service, presenter) = makeSUT()

		sut.handleViewDidAppear(request: .init())

		await service.waitUntilStarted()
		service.completeWithError(serviceError)

		await presenter.waitUntilPresented(expected: 3)
		XCTAssertEqual(presenter.messages, [
			.presentSearchLoading(true),
			.presentSearchError(serviceError),
			.presentSearchLoading(false)
		])
	}

	func test_search_presentsHotelsOnServiceSuccess() async {
		let hotels = [anyHotel(), anyHotel()]
		let (sut, service, presenter) = makeSUT()

		sut.handleViewDidAppear(request: .init())

		await service.waitUntilStarted()
		service.completeWithHotels(hotels)

		await presenter.waitUntilPresented(expected: 3)
		XCTAssertEqual(presenter.messages, [
			.presentSearchLoading(true),
			.presentSearch(.init(hotels: hotels)),
			.presentSearchLoading(false)
		])
	}

	func test_viewWillDisappearFromParent_cancelsInFlightSearch() async {
		let (sut, service, presenter) = makeSUT()

		sut.handleViewDidAppear(request: .init())
		await service.waitUntilStarted()

		// Bounded on purpose: if a regression detaches the search from the
		// cancelled task, the cancel never reaches the service and the flow
		// stalls. Fail fast instead of hanging until XCTest gives up.
		let searchCancelled = expectation(description: "Wait for search cancellation")
		service.onCancel = { searchCancelled.fulfill() }

		let nothingElsePresented = expectation(description: "Wait for further presentation")
		nothingElsePresented.isInverted = true
		presenter.onMessage = { nothingElsePresented.fulfill() }

		sut.handleViewWillDisappearFromParent(request: .init())

		await fulfillment(of: [searchCancelled, nothingElsePresented], timeout: 0.1)
		XCTAssertEqual(service.cancelCallCount, 1)
		XCTAssertEqual(
			presenter.messages,
			[.presentSearchLoading(true)],
			"A cancelled search should present nothing further — neither an error nor a loading change"
		)
	}

	func test_retry_requestsSearchAgain() async {
		let criteria = anySearchCriteria()
		let (sut, service, presenter) = makeSUT(criteria: criteria)

		sut.handleRetry(request: .init())
		await service.waitUntilStarted()

		XCTAssertEqual(service.receivedMessages(), [.search(criteria)])

		// Drain the in-flight request so no suspended task outlives the test.
		service.completeWithHotels([])
		await presenter.waitUntilPresented(expected: 3)
	}

	func test_retry_cancelsPreviousSearchWithoutTouchingLoading() async {
		let (sut, service, presenter) = makeSUT()

		sut.handleViewDidAppear(request: .init())
		await service.waitUntilStarted()

		// Regression: a second attempt supersedes the first. The superseded one
		// must not hide the loading indicator the new one has just shown.
		sut.handleRetry(request: .init())
		await service.waitUntilStarted()

		XCTAssertEqual(service.cancelCallCount, 1)

		service.completeWithHotels([], at: 1)
		await presenter.waitUntilPresented(expected: 4)

		// The superseded task's stray message can land either before or after
		// the surviving one's, so waiting for a fixed count is not enough:
		// hold the door open briefly and require that nothing else arrives.
		let nothingElsePresented = expectation(description: "Wait for further presentation")
		nothingElsePresented.isInverted = true
		presenter.onMessage = { nothingElsePresented.fulfill() }
		await fulfillment(of: [nothingElsePresented], timeout: 0.1)

		XCTAssertEqual(presenter.messages, [
			.presentSearchLoading(true),
			.presentSearchLoading(true),
			.presentSearch(.init(hotels: [])),
			.presentSearchLoading(false)
		], "The superseded search should contribute no messages of its own")
	}

	func test_viewWillDisappearFromParent_doesNotSearchWhenCriteriaArriveAfterCancellation() async {
		let provider = HotelsSearchCriteriaProviderSpy()
		let (sut, service, presenter) = makeSUT(provider: provider)

		sut.handleViewDidAppear(request: .init())
		await provider.waitUntilStarted()

		// Regression: the criteria retrieval is part of the cancellable flow.
		// The store completes regardless of cancellation, so leaving the screen
		// while it is in flight used to start a search nothing could stop.
		sut.handleViewWillDisappearFromParent(request: .init())

		let searchNotRequested = expectation(description: "Wait for search")
		searchNotRequested.isInverted = true
		service.onSearch = { searchNotRequested.fulfill() }

		provider.completeWithCriteria(anySearchCriteria())

		await fulfillment(of: [searchNotRequested], timeout: 0.1)
		XCTAssertTrue(service.receivedMessages().isEmpty)
		XCTAssertTrue(presenter.messages.isEmpty)
	}

	func test_filters_presentsFilters() async {
		let filters = anyHotelFilters()
		let (sut, _, presenter) = makeSUT()

		sut.doFetchFilters(request: .init())

		await presenter.waitUntilPresented()
		XCTAssertEqual(presenter.messages.last, .presentFilters(.init(filters: filters)))
	}

	func test_updateFilters_presentsUpdateFilters() async {
		let filters = anyHotelFilters()
		let (sut, _, presenter) = makeSUT()

		sut.handleFilterSelection(request: .init(filters: filters))

		await presenter.waitUntilPresented()
		XCTAssertEqual(presenter.messages.last, .presentUpdateFilter(.init(hotels: [])))
	}

	// MARK: - Helpers

	private func makeSUT(
		criteria: HotelsSearchCriteria = anySearchCriteria(),
		filters: HotelFilters = anyHotelFilters()
	) -> (
		sut: HotelsSearchInteractor,
		service: HotelsSearchServiceSpy,
		presenter: SearchPresentationLogicSpy
	) {
		makeSUT(
			provider: HotelsSearchCriteriaProviderStub(criteria: criteria),
			filters: filters
		)
	}

	private func makeSUT(
		provider: HotelsSearchCriteriaProvider,
		filters: HotelFilters = anyHotelFilters()
	) -> (
		sut: HotelsSearchInteractor,
		service: HotelsSearchServiceSpy,
		presenter: SearchPresentationLogicSpy
	) {
		let service = HotelsSearchServiceSpy()
		let presenter = SearchPresentationLogicSpy()
		let context = HotelsSearchContext(
			provider: provider,
			service: service
		)
		let sut = HotelsSearchInteractor(
			context: context,
			filters: filters,
			repository: DefaultHotelsRepository(),
			presenter: presenter
		)
		trackForMemoryLeaks(sut)
		trackForMemoryLeaks(service)
		trackForMemoryLeaks(presenter)
		return (sut, service, presenter)
	}
}

final class HotelsSearchServiceSpy: HotelsSearchService {
	enum Message: Equatable {
		case search(HotelsSearchCriteria)
	}

	/// Per-search state machine guaranteeing the continuation is resumed
	/// exactly once, no matter in which phase cancellation arrives (before
	/// suspension, while suspended, or racing a completion).
	private final class PendingSearch: Sendable {
		private enum State {
			case idle
			case suspended(CheckedContinuation<[Hotel], Error>)
			case finished
		}

		private let state = Mutex<State>(.idle)

		var isFinished: Bool {
			state.withLock {
				if case .finished = $0 { return true }
				return false
			}
		}

		/// Stores the continuation; returns `false` if the search already
		/// finished (e.g. was cancelled before it could suspend).
		func suspend(_ continuation: CheckedContinuation<[Hotel], Error>) -> Bool {
			state.withLock {
				guard case .idle = $0 else { return false }
				$0 = .suspended(continuation)
				return true
			}
		}

		/// Atomically extracts the continuation at most once.
		func take() -> CheckedContinuation<[Hotel], Error>? {
			state.withLock { state in
				defer { state = .finished }
				if case let .suspended(continuation) = state { return continuation }
				return nil
			}
		}
	}

	private let messages = Mutex<[Message]>([])
	private let pendingSearches = Mutex<[PendingSearch]>([])
	private let _cancelCallCount = Mutex<Int>(0)
	private let _onSearch = Mutex<(@Sendable () -> Void)?>(nil)
	private let _onCancel = Mutex<(@Sendable () -> Void)?>(nil)

	private let stream = AsyncStream<Void>.makeStream()

	var cancelCallCount: Int { _cancelCallCount.withLock { $0 } }

	var onSearch: (@Sendable () -> Void)? {
		get { _onSearch.withLock { $0 } }
		set { _onSearch.withLock { $0 = newValue } }
	}

	var onCancel: (@Sendable () -> Void)? {
		get { _onCancel.withLock { $0 } }
		set { _onCancel.withLock { $0 = newValue } }
	}

	func receivedMessages() -> [Message] {
		messages.withLock { $0 }
	}

	func search(criteria: HotelsSearchCriteria) async throws -> [Hotel] {
		messages.withLock { $0.append(.search(criteria)) }
		onSearch?()

		let pending = PendingSearch()

		return try await withTaskCancellationHandler {
			try await withCheckedThrowingContinuation { continuation in
				guard !pending.isFinished else {
					// Cancelled before suspension.
					return continuation.resume(throwing: CancellationError())
				}

				guard pending.suspend(continuation) else {
					// Cancelled between the check above and suspension.
					return continuation.resume(throwing: CancellationError())
				}

				pendingSearches.withLock { $0.append(pending) }
				stream.continuation.yield(())
			}
		} onCancel: { [weak self] in
			self?.recordCancellation()
			// Deterministic cancellation: wake the suspended search no matter
			// when the cancel arrives — a continuation must never stay parked.
			pending.take()?.resume(throwing: CancellationError())
		}
	}

	func completeWithHotels(_ hotels: [Hotel], at index: Int = 0) {
		let pending = pendingSearches.withLock { $0[index] }
		pending.take()?.resume(returning: hotels)
	}

	func completeWithError(_ error: Error, at index: Int = 0) {
		let pending = pendingSearches.withLock { $0[index] }
		pending.take()?.resume(throwing: error)
	}

	func waitUntilStarted() async {
		var iterator = stream.stream.makeAsyncIterator()
		_ = await iterator.next()
	}

	private func recordCancellation() {
		_cancelCallCount.withLock { $0 += 1 }
		onCancel?()
	}
}

final class SearchPresentationLogicSpy: HotelsSearchPresentationLogic {
	enum Message: Equatable {
		case presentSearch(HotelsSearchModels.Search.Response)
		case presentSearchLoading(Bool)
		case presentSearchError(NSError)
		case presentFilters(HotelsSearchModels.FetchFilters.Response)
		case presentUpdateFilter(HotelsSearchModels.FilterSelection.Response)
	}

	private(set) var messages = [Message]()

	/// Called after every recorded message, so a test can bound its wait with an
	/// expectation. `waitUntilPresented` suspends until the expected number of
	/// messages arrives, which is what we want while the flow runs — but a
	/// regression that stalls the flow turns that into a hang, and the test then
	/// reports nothing until XCTest's global allowance expires.
	var onMessage: (() -> Void)?

	private let stream = AsyncStream<Void>.makeStream()

	func presentSearch(response: HotelsSearchModels.Search.Response) {
		record(.presentSearch(response))
	}

	func presentSearchLoading(_ isLoading: Bool) {
		record(.presentSearchLoading(isLoading))
	}

	func presentSearchError(_ error: Error) {
		record(.presentSearchError(error as NSError))
	}

	func presentFilters(response: HotelsSearchModels.FetchFilters.Response) {
		record(.presentFilters(response))
	}

	func presentUpdateFilters(response: HotelsSearchModels.FilterSelection.Response) {
		record(.presentUpdateFilter(response))
	}

	private func record(_ message: Message) {
		messages.append(message)
		stream.continuation.yield(())
		onMessage?()
	}

	func waitUntilPresented(expected count: Int = 1) async {
		var iterator = stream.stream.makeAsyncIterator()
		for _ in 0..<count {
			_ = await iterator.next()
		}
	}
}

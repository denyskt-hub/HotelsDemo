//
//  ImageDataLoaderAdapterTests.swift
//  HotelsDemoTests
//

import XCTest
import HotelsDemo
import ImageLoadingKit

@MainActor
final class ImageDataLoaderAdapterTests: XCTestCase {
	func test_didSetImageWith_presentsLoadedImageData() async {
		let data = anyData()
		let (sut, loader, presenter) = makeSUT()

		sut.didSetImageWith(anyURL())
		await loader.waitUntilStarted()
		loader.completeWithData(data)

		await presenter.waitUntilLoadingFinished()
		XCTAssertEqual(presenter.messages, [
			.presentLoading(true),
			.presentImageData(data),
			.presentLoading(false)
		])
	}

	func test_didSetImageWith_presentsErrorOnLoaderError() async {
		let error = anyNSError()
		let (sut, loader, presenter) = makeSUT()

		sut.didSetImageWith(anyURL())
		await loader.waitUntilStarted()
		loader.completeWithError(error)

		await presenter.waitUntilLoadingFinished()
		XCTAssertEqual(presenter.messages, [
			.presentLoading(true),
			.presentImageDataError,
			.presentLoading(false)
		])
	}

	func test_didCancel_cancelsInFlightLoad() async {
		let (sut, loader, presenter) = makeSUT()

		sut.didSetImageWith(anyURL())
		await loader.waitUntilStarted()

		// Regression: the cancel must apply even though the load task was
		// just created — registration is synchronous, a cancel can no longer
		// overtake it.
		sut.didCancel()

		await presenter.waitUntilLoadingFinished()
		XCTAssertEqual(loader.cancelledURLs, [anyURL()])
		XCTAssertEqual(presenter.messages, [
			.presentLoading(true),
			.presentLoading(false)
		], "Cancellation should be silenced, not presented as an error")
	}

	func test_didSetImageWith_cancelsPreviousLoad() async {
		let firstURL = URL(string: "https://first.com")!
		let secondURL = URL(string: "https://second.com")!
		let data = anyData()
		let (sut, loader, presenter) = makeSUT()

		sut.didSetImageWith(firstURL)
		await loader.waitUntilStarted()

		// Regression: a newer request must cancel exactly the older one —
		// registrations can no longer be reordered.
		sut.didSetImageWith(secondURL)
		await loader.waitUntilStarted()

		XCTAssertEqual(loader.cancelledURLs, [firstURL])

		loader.completeWithData(data, at: 1)
		await presenter.waitUntilLoadingFinished(times: 2)
		XCTAssertEqual(presenter.messages.last, .presentLoading(false))
		XCTAssertTrue(presenter.messages.contains(.presentImageData(data)))
	}

	// MARK: - Helpers

	private func makeSUT() -> (
		sut: ImageDataLoaderAdapter,
		loader: ImageDataLoaderSpy,
		presenter: ImageDataPresentationLogicSpy
	) {
		let loader = ImageDataLoaderSpy()
		let presenter = ImageDataPresentationLogicSpy()
		let sut = ImageDataLoaderAdapter(
			loader: loader,
			presenter: presenter
		)
		trackForMemoryLeaks(loader)
		trackForMemoryLeaks(presenter)
		trackForMemoryLeaks(sut)
		return (sut, loader, presenter)
	}
}

@MainActor
final class ImageDataPresentationLogicSpy: ImageDataPresentationLogic {
	enum Message: Equatable {
		case presentLoading(Bool)
		case presentImageData(Data)
		case presentImageDataError
	}

	private(set) var messages = [Message]()
	private var loadingFinishedContinuations = [CheckedContinuation<Void, Never>]()
	private var loadingFinishedCount = 0

	func presentImageData(_ data: Data) {
		messages.append(.presentImageData(data))
	}

	func presentImageDataError(_ error: Error) {
		messages.append(.presentImageDataError)
	}

	func presentLoading(_ isLoading: Bool) {
		messages.append(.presentLoading(isLoading))

		if !isLoading {
			loadingFinishedCount += 1
			loadingFinishedContinuations.forEach { $0.resume() }
			loadingFinishedContinuations.removeAll()
		}
	}

	/// Suspends until `presentLoading(false)` has been delivered `times`
	/// times — the adapter's task is then past its final presenter call.
	func waitUntilLoadingFinished(times: Int = 1) async {
		while loadingFinishedCount < times {
			await withCheckedContinuation { continuation in
				loadingFinishedContinuations.append(continuation)
			}
		}
	}
}

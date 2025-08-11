//
//  FallbackImageDataLoaderTests.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 17/7/25.
//

import XCTest
import HotelsDemo

final class FallbackImageDataLoaderTests: XCTestCase, ImageDataLoaderTestCase {
	func test_load_deliversPrimaryResultOnSuccess() {
		let primaryData = anyData()
		let (sut, primary, _) = makeSUT()

		expect(sut, toLoad: .success(primaryData), when: {
			primary.completeWith(.success(primaryData))
		})
	}

	func test_load_deliversSecondaryResultOnPrimaryFailure() {
		let (primaryError, secondaryData) = (anyNSError(), anyData())
		let (sut, primary, secondary) = makeSUT()

		expect(sut, toLoad: .success(secondaryData), when: {
			primary.completeWith(.failure(primaryError))
			secondary.completeWith(.success(secondaryData))
		})
	}

	func test_load_deliversErrorWhenBothPrimaryAndSecondaryFail() {
		let (primaryError, secondaryError) = (anyNSError(), anyNSError())
		let (sut, primary, secondary) = makeSUT()

		expect(sut, toLoad: .failure(secondaryError), when: {
			primary.completeWith(.failure(primaryError))
			secondary.completeWith(.failure(secondaryError))
		})
	}

	// MARK: - Helpers

	private func makeSUT() -> (
		sut: FallbackImageDataLoader,
		primary: ImageDataLoaderSpy,
		secondary: ImageDataLoaderSpy
	) {
		let primary = ImageDataLoaderSpy()
		let secondary = ImageDataLoaderSpy()
		let sut = FallbackImageDataLoader(primary: primary, secondary: secondary)
		return (sut, primary, secondary)
	}
}

final class ImageDataLoaderSpy: ImageDataLoader {
	private(set) var messages = [URL]()
	private(set) var tasks = [TaskSpy]()
	private var completions = [LoadCompletion]()

	final class TaskSpy: ImageDataLoaderTask {
		private(set) var cancelCallCount = 0

		func cancel() {
			cancelCallCount += 1
		}
	}

	func load(url: URL, completion: @escaping LoadCompletion) -> ImageDataLoaderTask {
		messages.append(url)
		completions.append(completion)

		let task = TaskSpy()
		tasks.append(task)
		return task
	}

	func completeWith(_ result: LoadResult, at index: Int = 0) {
		completions[index](result)
	}
}

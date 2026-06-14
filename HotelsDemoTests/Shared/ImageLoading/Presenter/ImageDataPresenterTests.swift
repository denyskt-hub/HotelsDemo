//
//  ImageDataPresenterTests.swift
//  HotelsDemoTests
//
//  Created by Denys Kotenko on 14.06.2026.
//

import XCTest
import UIKit
import HotelsDemo

@MainActor
final class ImageDataPresenterTests: XCTestCase {
	func test_presentImageData_withValidData_displaysImage() {
		let (sut, view) = makeSUT()

		sut.presentImageData(validImageData())

		XCTAssertEqual(view.messages, [.displayImage])
	}

	func test_presentImageData_withUndecodableData_displaysPlaceholder() {
		let (sut, view) = makeSUT()

		sut.presentImageData(Data("not an image".utf8))

		XCTAssertEqual(view.messages, [.displayPlaceholder])
	}

	func test_presentImageDataError_displaysPlaceholder() {
		let (sut, view) = makeSUT()

		sut.presentImageDataError(anyNSError())

		XCTAssertEqual(view.messages, [.displayPlaceholder])
	}

	func test_presentLoading_forwardsLoadingState() {
		let (sut, view) = makeSUT()

		sut.presentLoading(true)
		sut.presentLoading(false)

		XCTAssertEqual(view.messages, [.displayLoading(true), .displayLoading(false)])
	}

	// MARK: - Helpers

	private func makeSUT(
		file: StaticString = #filePath,
		line: UInt = #line
	) -> (sut: ImageDataPresenter, view: ImageDisplayLogicSpy) {
		let view = ImageDisplayLogicSpy()
		let sut = ImageDataPresenter(view: view)
		trackForMemoryLeaks(view, file: file, line: line)
		trackForMemoryLeaks(sut, file: file, line: line)
		return (sut, view)
	}

	private func validImageData() -> Data {
		UIImage(systemName: "photo")!.pngData()!
	}
}

private final class ImageDisplayLogicSpy: ImageDisplayLogic {
	enum Message: Equatable {
		case displayImage
		case displayPlaceholder
		case displayLoading(Bool)
	}

	private(set) var messages = [Message]()

	func displayImage(_ image: UIImage) {
		messages.append(.displayImage)
	}

	func displayPlaceholderImage(_ image: UIImage) {
		messages.append(.displayPlaceholder)
	}

	func displayLoading(_ isLoading: Bool) {
		messages.append(.displayLoading(isLoading))
	}
}

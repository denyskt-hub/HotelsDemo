//
//  FallbackImageDataLoaderTests.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 17/7/25.
//

import XCTest
import HotelsDemo
import Synchronization

@MainActor
final class FallbackImageDataLoaderTests: XCTestCase, ImageDataLoaderTestCase {
	func test_load_deliversPrimaryResultOnSuccess() async {
		let primaryData = anyData()
		let (sut, primary, _) = makeSUT()

		await expect(sut, toLoadData: primaryData, when: {
			primary.stubWithData(primaryData)
		})
	}

	func test_load_deliversSecondaryResultOnPrimaryFailure() async {
		let (primaryError, secondaryData) = (anyNSError(), anyData())
		let (sut, primary, secondary) = makeSUT()

		await expect(sut, toLoadData: secondaryData, when: {
			primary.stubWithError(primaryError)
			secondary.stubWithData(secondaryData)
		})
	}

	func test_load_deliversErrorWhenBothPrimaryAndSecondaryFail() async {
		let (primaryError, secondaryError) = (anyNSError(), anyNSError())
		let (sut, primary, secondary) = makeSUT()

		await expect(sut, toLoadWithError: secondaryError, when: {
			primary.stubWithError(primaryError)
			secondary.stubWithError(secondaryError)
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

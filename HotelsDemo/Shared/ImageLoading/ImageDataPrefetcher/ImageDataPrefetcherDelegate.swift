//
//  ImageDataPrefetcherDelegate.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 3/12/25.
//

import Foundation

///
/// Receives lifecycle callbacks from an `ImageDataPrefetcher`.
///
/// Note: Implementations must be thread-safe. The prefetcher may call these
/// methods from a background thread; callbacks are not guaranteed to occur on
/// the main thread.
///
public protocol ImageDataPrefetcherDelegate: AnyObject, Sendable {
	func imageDataPrefetcher(_ prefetcher: ImageDataPrefetcher, willPrefetchDataForURL url: URL)
	func imageDataPrefetcher(_ prefetcher: ImageDataPrefetcher, didPrefetchDataForURL url: URL)
}

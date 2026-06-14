//
//  ImageDataPresenter.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 19/7/25.
//

import UIKit

public final class ImageDataPresenter: ImageDataPresentationLogic {
	private let view: ImageDisplayLogic

	public init(view: ImageDisplayLogic) {
		self.view = view
	}

	public func presentImageData(_ data: Data) {
		guard let image = UIImage(data: data) else {
			Logger.log("Failed to decode image from \(data.count) bytes of data.", level: .error, tag: .custom("image"))
			presentPlaceholder()
			return
		}
		view.displayImage(image)
	}

	public func presentImageDataError(_ error: Error) {
		Logger.log("Image load failed: \(error)", level: .error, tag: .custom("image"))
		presentPlaceholder()
	}

	public func presentLoading(_ isLoading: Bool) {
		view.displayLoading(isLoading)
	}

	private func presentPlaceholder() {
		guard let placeholderImage = UIImage(systemName: "photo") else { return }
		view.displayPlaceholderImage(placeholderImage)
	}
}

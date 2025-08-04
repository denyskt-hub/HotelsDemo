//
//  ImageDataPresenter.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 19/7/25.
//

import UIKit

public final class ImageDataPresenter: ImageDataPresentationLogic {
	public weak var view: ImageDisplayLogic?

	public func presentImageData(_ data: Data) {
		guard let image = UIImage(data: data) else { return }
		view?.displayImage(image)
	}

	public func presentImageDataError(_ error: Error) {
		guard let placeholderImage = UIImage(systemName: "photo") else { return }
		view?.displayPlaceholderImage(placeholderImage)
	}

	public func presentLoading(_ isLoading: Bool) {
		view?.displayLoading(isLoading)
	}
}

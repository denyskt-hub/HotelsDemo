//
//  HotelCellController.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 14/7/25.
//

import UIKit

@MainActor
public final class HotelCellController: NSObject {
	private let viewModel: HotelsSearchModels.HotelViewModel
	private let prefetcher: ImageDataPrefetcher

	public init(
		viewModel: HotelsSearchModels.HotelViewModel,
		prefetcher: ImageDataPrefetcher = SharedImageDataPrefetcher.instance
	) {
		self.viewModel = viewModel
		self.prefetcher = prefetcher
	}
}

// MARK: - UITableViewDataSource

extension HotelCellController: UITableViewDataSource {
	public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		1
	}

	public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell: HotelCell = tableView.dequeueReusableCell()
		cell.configure(with: viewModel)
		return cell
	}
}

// MARK: - UITableViewDataSourcePrefetching

extension HotelCellController: UITableViewDataSourcePrefetching {
	public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
		prefetcher.prefetch(urls: photoURLs())
	}

	public func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
		prefetcher.cancelPrefetching(urls: photoURLs())
	}

	private func photoURLs() -> [URL] {
		[viewModel.photoURL].compactMap { $0 }
	}
}

// MARK: - UITableViewDelegate

extension HotelCellController: UITableViewDelegate {
	public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		loadImage(with: viewModel.photoURL, for: cell as? HotelCell)
	}

	public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		cancelImageLoad(for: cell as? HotelCell)
	}
}

extension HotelCellController {
	private func loadImage(with url: URL?, for cell: HotelCell?) {
		guard let url = url else { return }
		cell?.photoImageView.setImage(url)
	}

	private func cancelImageLoad(for cell: HotelCell?) {
		cell?.photoImageView.setImage(nil)
	}
}

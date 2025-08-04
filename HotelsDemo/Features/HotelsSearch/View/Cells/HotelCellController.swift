//
//  HotelCellController.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 14/7/25.
//

import UIKit

public final class HotelCellController: NSObject {
	private let viewModel: HotelsSearchModels.HotelViewModel

	public init(viewModel: HotelsSearchModels.HotelViewModel) {
		self.viewModel = viewModel
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

// MARK: - UITableViewDelegate

extension HotelCellController: UITableViewDelegate {
	public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		let hotelCell = cell as? HotelCell
		if let url = viewModel.photoURL {
			hotelCell?.photoImageView.setImage(url)
		}
	}

	public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		let hotelCell = cell as? HotelCell
		hotelCell?.photoImageView.setImage(nil)
	}
}

//
//  HotelCellController.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 14/7/25.
//

import UIKit

public protocol HotelCellControllerDelegate {
	func didRequestPhoto(_ url: URL)
	func didCancelPhotoRequest()
}

public final class HotelCellController: NSObject {
	private let viewModel: SearchModels.HotelViewModel
	private var cell: HotelCell?

	public var delegate: HotelCellControllerDelegate?

	public init(viewModel: SearchModels.HotelViewModel) {
		self.viewModel = viewModel
	}
}

extension HotelCellController: UITableViewDataSource {
	public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		1
	}
	
	public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell: HotelCell = tableView.dequeueReusableCell()
		cell.configure(with: viewModel)
		self.cell = cell
		return cell
	}
}

extension HotelCellController: UITableViewDelegate {
	public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		self.cell = cell as? HotelCell
		if let url = viewModel.photoURL {
			delegate?.didRequestPhoto(url)
		}
	}

	public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		self.cell = nil
		delegate?.didCancelPhotoRequest()
	}
}

extension HotelCellController: ImageView {
	public func displayImage(_ image: UIImage) {
		cell?.photoImageView.image = image
	}
}

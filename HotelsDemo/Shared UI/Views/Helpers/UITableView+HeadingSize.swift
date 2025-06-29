//
//  UITableView+HeadingSize.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 29/6/25.
//

import UIKit

extension UITableView {
	func sizeTableHeaderToFit() {
		guard let header = tableHeaderView else { return }

		let size = header.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)

		let needsFrameUpdate = header.frame.height != size.height
		if needsFrameUpdate {
			header.frame.size.height = size.height
			tableHeaderView = header
		}
	}
}

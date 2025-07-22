//
//  CellController.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 21/7/25.
//

import UIKit

public struct CellController {
	public let dataSource: UITableViewDataSource

	public init(_ dataSource: UITableViewDataSource) {
		self.dataSource = dataSource
	}
}

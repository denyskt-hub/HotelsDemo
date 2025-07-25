//
//  IntrinsicTableView.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 25/7/25.
//

import UIKit

///
/// A UITableView that automatically sizes itself based on its content.
///
/// This is useful when embedding the table view in a UIStackView, where the stack view
/// relies on subviews' intrinsicContentSize. Normally, UITableView does not have an
/// intrinsic height, so this subclass ensures the table grows to fit its content.
///
/// Important: Remember to set `isScrollEnabled = false` when using this in a stack view.
///
public final class IntrinsicTableView: UITableView {
	public override var intrinsicContentSize: CGSize {
		self.layoutIfNeeded()
		return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
	}

	public override func reloadData() {
		super.reloadData()
		self.invalidateIntrinsicContentSize()
	}

	public override func layoutSubviews() {
		super.layoutSubviews()
		self.invalidateIntrinsicContentSize()
	}
}

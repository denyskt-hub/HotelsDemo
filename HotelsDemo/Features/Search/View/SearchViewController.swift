//
//  SearchViewController.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 12/7/25.
//

import UIKit

public final class SearchViewController: NiblessViewController {
	private let rootView = SearchRootView()

	public override func loadView() {
		view = rootView
	}
}

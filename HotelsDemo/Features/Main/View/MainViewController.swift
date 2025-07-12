//
//  MainViewController.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 11/7/25.
//

import UIKit

public final class MainViewController: NiblessViewController, MainDisplayLogic {
	private let rootView = MainRootView()
	private let searchCriteriaViewController: UIViewController

	private var searchCriteriaContainerView: UIView { rootView.searchCriteriaContainerView }

	public var interactor: MainBusinessLogic?
	public var router: MainRoutingLogic?

	public init(searchCriteriaViewController: UIViewController) {
		self.searchCriteriaViewController = searchCriteriaViewController
		super.init()
	}

	public override func loadView() {
		view = rootView
	}

	public override func viewDidLoad() {
		super.viewDidLoad()

		addChild(searchCriteriaViewController, to: searchCriteriaContainerView)
	}
}

extension MainViewController: SearchCriteriaDelegate {
	public func didRequestSearch(with searchCriteria: SearchCriteria) {
		
	}
}

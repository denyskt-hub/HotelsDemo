//
//  ImageView.swift
//  HotelsDemo
//
//  Created by Denys Kotenko on 4/8/25.
//

import UIKit

public protocol ImageViewDelegate: AnyObject, Sendable {
	func didSetImageWith(_ url: URL)
	func didCancel()
}

public class ImageView: ShimmeringView, ImageDisplayLogic {
	private let delegate: ImageViewDelegate
	private var hierarchyNotReady = true

	public let view: UIImageView = {
		let view = UIImageView()
		view.setContentHuggingPriority(UILayoutPriority(rawValue: 1000), for: .vertical)
		view.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
		return view
	}()

	public var image: UIImage? {
		get { view.image }
		set { view.image = newValue }
	}

	public override var contentMode: UIView.ContentMode {
		get { view.contentMode }
		set { view.contentMode = newValue }
	}

	public override var tintColor: UIColor! {
		get { view.tintColor }
		set { view.tintColor = newValue }
	}

	public override init(frame: CGRect) {
		let viewProxy = WeakRefVirtualProxy<ImageView>()
		let presenter = ImageDataPresenter(view: viewProxy)
		let adapter = ImageDataLoaderAdapter(
			loader: SharedImageDataLoader.instance,
			presenter: presenter
		)
		self.delegate = adapter

		super.init(frame: frame)
		viewProxy.object = self
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	public override func didMoveToWindow() {
		super.didMoveToWindow()

		guard hierarchyNotReady else {
			return
		}

		setupHierarchy()
		activateConstraints()
		hierarchyNotReady = false
	}

	private func setupHierarchy() {
		addSubview(view)
	}

	private func activateConstraints() {
		activateConstraintsView()
	}

	private var currentURL: URL?

	public func setImage(_ url: URL?) {
		guard currentURL != url else { return }

		currentURL = url
		image = nil

		if let url = url {
			delegate.didSetImageWith(url)
		} else {
			delegate.didCancel()
		}
	}

	public func displayImage(_ image: UIImage) {
		self.image = image
		contentMode = .scaleAspectFill
	}

	public func displayPlaceholderImage(_ image: UIImage) {
		self.image = image
		self.contentMode = .center
	}

	public func displayLoading(_ isLoading: Bool) {
		isShimmering = isLoading
	}
}

// MARK: - Layout

extension ImageView {
	private func activateConstraintsView() {
		view.translatesAutoresizingMaskIntoConstraints = false
		let leading = view.leadingAnchor.constraint(equalTo: leadingAnchor)
		let trailing = view.trailingAnchor.constraint(equalTo: trailingAnchor)
		let top = view.topAnchor.constraint(equalTo: topAnchor)
		let bottom = view.bottomAnchor.constraint(equalTo: bottomAnchor)
		NSLayoutConstraint.activate([leading, trailing, top, bottom])
	}
}

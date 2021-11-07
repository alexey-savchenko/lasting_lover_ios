//
//  FavoritesViewController.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 07.11.2021.
//

import Foundation
import UIKit

class FavoritesViewController: ViewController<BackgroundImageView> {
	let viewModel: FavoritesControllerViewModel

	let navbar = NavbarViewBase()

	init(viewModel: FavoritesControllerViewModel) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		setupUI()
		configure(with: viewModel)
	}

	fileprivate func setupNavbar() {
		navbar.setRightButtonImage(Asset.Images.setting.image.tinted(Asset.Colors.white.color))
		navbar.snp.makeConstraints { make in
			make.leading.trailing.equalToSuperview()
			make.top.equalTo(view.safeAreaLayoutGuide)
			make.height.equalTo(44)
		}
	}

	func setupUI() {
		[navbar]
			.forEach(view.addSubview)

		setupNavbar()
	}

	func configure(with viewModel: FavoritesControllerViewModel) {}
}

//
//  DiscoverViewController.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 03.10.2021.
//

import UIKit

class DiscoverViewController: ViewController<BackgroundImageView> {
  let viewModel: DiscoverControllerViewModel

  let topArtworkImageView = UIImageView(image: Asset.Images.lips.image)
  let navbar = NavbarViewBase()
	let titleLabel = UILabel()

  init(viewModel: DiscoverControllerViewModel) {
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

  fileprivate func setupTopArtwork() {
    topArtworkImageView.contentMode = .scaleAspectFit
    topArtworkImageView.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.trailing.equalToSuperview().offset(40)
    }
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
    [topArtworkImageView, navbar, titleLabel]
      .forEach(view.addSubview)

    setupTopArtwork()
    setupNavbar()
		titleLabel.attributedText = NSAttributedString(
			string: L10n.discoverNewImpressions,
			attributes: [
				.foregroundColor: Asset.Colors.white.color,
				.font: FontFamily.Nunito.bold.font(size: 36)
			]
		)
		titleLabel.numberOfLines = 0
		titleLabel.snp.makeConstraints { make in
			make.leading.equalToSuperview().offset(16)
			make.top.equalTo(navbar)
			make.trailing.equalToSuperview().offset(-32)
		}
  }

  func configure(with viewModel: DiscoverControllerViewModel) {
		
	}
}

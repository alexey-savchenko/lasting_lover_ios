//
//  SleepViewController.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 03.10.2021.
//

import UIKit

class SleepViewController: ViewController<BackgroundImageView> {
  let viewModel: SleepControllerViewModel

  let navbar = NavbarViewBase()

  init(viewModel: SleepControllerViewModel) {
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
    navbar.setTitle(
      NSAttributedString(
        string: "Lasting lover",
        attributes: [
          .foregroundColor: Asset.Colors.white.color,
          .font: FontFamily.Nunito.semiBold.font(size: 22)
        ]
      )
    )
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

  func configure(with viewModel: SleepControllerViewModel) {}
}

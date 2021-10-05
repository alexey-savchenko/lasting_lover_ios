//
//  SettingsViewController.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 05.10.2021.
//

import UIKit
import RxSwift

class SettingsViewController: ViewController<BackgroundImageView> {
  
  let navbar = BackButtonNavbarView()
  
  let titleLabel = UILabel()
  
  let disposeBag = DisposeBag()
  let viewModel: SettingsControllerViewModel
  
  init(viewModel: SettingsControllerViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  deinit {
    print("\(self) dealloc")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupUI()
    configure(with: viewModel)
  }
  
  fileprivate func setupTitleLabel() {
    titleLabel.attributedText = NSAttributedString(
      string: L10n.settings,
      attributes: [
        .foregroundColor: Asset.Colors.white.color,
        .font: FontFamily.Nunito.bold.font(size: 36)
      ]
    )
    titleLabel.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(24)
      make.top.equalTo(navbar.snp.bottom).offset(4)
    }
  }
  
  fileprivate func setupNavBar() {
    navbar.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview()
      make.top.equalTo(view.safeAreaLayoutGuide)
      make.height.equalTo(44)
    }
  }
  
  func setupUI() {
    [navbar, titleLabel].forEach(view.addSubview)
    
    setupNavBar()
    setupTitleLabel()
  }
  
  func configure(with viewModel: SettingsControllerViewModel) {
    
  }
}

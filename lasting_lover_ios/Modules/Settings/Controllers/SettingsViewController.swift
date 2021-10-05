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
  
  let disposeBag = DisposeBag()
  let viewModel: SettingsControllerViewModel
  
  init(viewModel: SettingsControllerViewModel) {
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
  
  func setupUI() {
    [navbar].forEach(view.addSubview)
    navbar.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview()
      make.top.equalTo(view.safeAreaLayoutGuide)
      make.height.equalTo(44)
    }
  }
  
  func configure(with viewModel: SettingsControllerViewModel) {
    
  }
}

//
//  SplashViewController.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 30.09.2021.
//

import UIKit
import SnapKit

class SplashViewController: UIViewController {
  
  let titleLabel = UILabel()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white
    view.addSubview(titleLabel)
    titleLabel.textColor = .black
    titleLabel.text = "Lasting lover"
    titleLabel.snp.makeConstraints { make in
      make.center.equalToSuperview()
    }
  }
}

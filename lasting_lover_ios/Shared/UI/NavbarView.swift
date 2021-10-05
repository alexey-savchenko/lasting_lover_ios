//
//  NavbarView.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 01.10.2021.
//

import UIKit

class NavbarViewBase: UIView {

  let titleLabel = UILabel()
  let rightButton = UIButton()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setupUI() {
    [titleLabel, rightButton].forEach(addSubview)
    titleLabel.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(24)
      make.centerY.equalToSuperview()
    }
    rightButton.snp.makeConstraints { make in
      make.size.equalTo(24)
      make.trailing.equalToSuperview().offset(-24)
      make.centerY.equalToSuperview()
    }
  }
  
  func setTitle(_ str: NSAttributedString) {
    titleLabel.attributedText = str
  }
  
  func setRightButtonImage(_ image: UIImage) {
    rightButton.setImage(image, for: .normal)
  }
}

class BackButtonNavbarView: NavbarViewBase {
  
  let backButton = UIButton()
  
  fileprivate func setupBackButton() {
    backButton.setImage(Asset.Images.chevronLeft.image.tinted(Asset.Colors.white.color), for: .normal)
    backButton.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(24)
      make.centerY.equalToSuperview()
      make.size.equalTo(24)
    }
  }
  
  override func setupUI() {
    super.setupUI()
    
    addSubview(backButton)
    setupBackButton()
    
    titleLabel.snp.remakeConstraints { make in
      make.center.equalToSuperview()
      make.leading.equalTo(backButton.snp.trailing).offset(16)
      make.trailing.equalTo(rightButton.snp.leading).offset(-16)
    }
  }
}

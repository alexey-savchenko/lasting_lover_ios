//
//  SignInTitleViewController.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 30.09.2021.
//

import UIKit

class AuthTitleViewController: ViewController<BackgroundImageView> {
  
  let titleImageView = UIImageView(image: Asset.Images.signInTitleimage.image)
  
  let labelsStackView = UIStackView()
  
  let titleLabel = UILabel()
  let subtitleLabel = UILabel()
  
  let buttonsStackView = UIStackView()
  
  let signInButton = Button(style: .secondary, title: L10n.signInTitleScreenSignInButtonTitle)
  let signUpButton = Button(style: .primary, title: L10n.signInTitleScreenSignUpButtonTitle)
  
  fileprivate func setupLabelsStackView() {
    [titleLabel, subtitleLabel]
      .forEach { l in
        labelsStackView.addArrangedSubview(l)
        l.textAlignment = .center
        l.textColor = .white
        l.numberOfLines = 0
      }
    labelsStackView.axis = .vertical
    labelsStackView.alignment = .center
    labelsStackView.spacing = 16
    labelsStackView.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview().inset(24)
      make.bottom.equalTo(buttonsStackView.snp.top).offset(-32)
    }
    
    titleLabel.text = L10n.signInTitleScreenTitle
    titleLabel.font = FontFamily.Nunito.bold.font(size: 36)
    subtitleLabel.text = L10n.signInTitleScreenSubtitle
    subtitleLabel.font = FontFamily.Nunito.semiBold.font(size: 17)
  }
  
  fileprivate func setupButtonsStackView() {
    [signUpButton,
     signInButton]
      .forEach { b in
        buttonsStackView.addArrangedSubview(b)
        b.snp.makeConstraints { make in
          make.height.equalTo(56)
        }
        b.clipsToBounds = true
        b.layer.cornerRadius = 28
      }
    
    buttonsStackView.axis = .vertical
    buttonsStackView.spacing = 16
    buttonsStackView.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview().inset(24)
      make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-40)
    }
  }
  
  fileprivate func setupTitleImageView() {
    titleImageView.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
      make.leading.trailing.equalToSuperview()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .gray
    
    [titleImageView,
     labelsStackView,
     buttonsStackView]
      .forEach(view.addSubview)
    
    setupTitleImageView()
    setupLabelsStackView()
    setupButtonsStackView()
  }
}

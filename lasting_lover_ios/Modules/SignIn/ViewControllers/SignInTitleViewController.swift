//
//  SignInTitleViewController.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 30.09.2021.
//

import UIKit

class SignInTitleViewController: UIViewController {
  
  let titleImageView = UIImageView(image: Asset.Images.signInTitleimage.image)
  
  let labelsStackView = UIStackView()
  
  let titleLabel = UILabel()
  let subtitleLabel = UILabel()
  
  let buttonsStackView = UIStackView()
  
  let signInButton = UIButton()
  let signUpButton = UIButton()
  
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
    titleLabel.font = UIFont.systemFont(ofSize: 36, weight: .bold)
    subtitleLabel.text = L10n.signInTitleScreenSubtitle
    subtitleLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
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
    
    signUpButton.setBackgroundImage(UIImage(color: Asset.Colors.button.color), for: .normal)
    signUpButton.setAttributedTitle(
      NSAttributedString(
        string: L10n.signInTitleScreenTitle,
        attributes: [
          .foregroundColor: Asset.Colors.white.color,
          .font: UIFont.systemFont(ofSize: 16)
        ]
      ),
      for: .normal
    )
    signInButton.setBackgroundImage(UIImage(color: Asset.Colors.white.color), for: .normal)
    signInButton.setAttributedTitle(
      NSAttributedString(
        string: L10n.signInTitleScreenSignInButtonTitle,
        attributes: [
          .foregroundColor: Asset.Colors.white.color,
          .font: UIFont.systemFont(ofSize: 16)
        ]
      ),
      for: .normal
    )
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .gray
    
    [titleImageView,
     labelsStackView,
     buttonsStackView]
      .forEach(view.addSubview)
    
    setupLabelsStackView()
    setupButtonsStackView()
  }
}

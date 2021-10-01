//
//  SignUpViewController.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 01.10.2021.
//

import UIKit

class AuthViewController: UIViewController {
  
  let backgroundView = BackgroundFlareImageView(frame: .zero)
  let navbarView = BackButtonNavbarView()
  
  let titleLabelsStackView = UIStackView()
  let titleLabel = UILabel()
  let subtitleLabel = UILabel()
  
  let textfieldsStackView = UIStackView()
  let mailTextfieldView = TextfieldView(placeholder: L10n.signInEmailTextfieldPlaceholder)
  let passwordTextfieldView = TextfieldView(placeholder: L10n.signInPassTextfieldPlaceholder)
  
  let forgotPasswordButton = UIButton()
  
  let submitButton = UIButton()
  
  let hintLabel = UILabel()
  
  let appleSignUpButton = UIButton()
  
  let modeSwitchButton = UIButton()
  
  fileprivate func setupNavbarView() {
    navbarView.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview()
      make.top.equalTo(view.safeAreaLayoutGuide)
      make.height.equalTo(44)
    }
  }
  
  fileprivate func setupBackgroundImageView() {
    backgroundView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    [
      backgroundView,
      navbarView,
      titleLabelsStackView,
      textfieldsStackView,
      submitButton,
      forgotPasswordButton,
      hintLabel,
      appleSignUpButton,
      modeSwitchButton
    ]
    .forEach(view.addSubview)
    
    setupBackgroundImageView()
    setupNavbarView()
    
    modeSwitchButton.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview().offset(16)
      make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-28)
    }
    
  }
  
  func switchModeButtonTitle(_ mode: AuthModuleLaunchMode) -> NSAttributedString {
    switch mode {
    case .signIn:
      let modeSwitchButtonTitle = NSMutableAttributedString()
      modeSwitchButtonTitle.append(
        NSAttributedString(
          string: L10n.signInSwitchModeButtonTitlePart1 + " ",
          attributes: [
            .foregroundColor: Asset.Colors.white.color,
            .font: FontFamily.Nunito.regular.font(size: 12)
          ]
        )
      )
      modeSwitchButtonTitle.append(
        NSAttributedString(
          string: L10n.signInSwitchModeButtonTitlePart2,
          attributes: [
            .foregroundColor: Asset.Colors.white.color,
            .font: FontFamily.Nunito.bold.font(size: 12)
          ]
        )
      )
      return modeSwitchButtonTitle
    case .signUp:
      let modeSwitchButtonTitle = NSMutableAttributedString()
      modeSwitchButtonTitle.append(
        NSAttributedString(
          string: L10n.signInSwitchModeButtonTitlePart1 + " ",
          attributes: [
            .foregroundColor: Asset.Colors.white.color,
            .font: FontFamily.Nunito.regular.font(size: 12)
          ]
        )
      )
      modeSwitchButtonTitle.append(
        NSAttributedString(
          string: L10n.signInSwitchModeButtonTitlePart2,
          attributes: [
            .foregroundColor: Asset.Colors.white.color,
            .font: FontFamily.Nunito.bold.font(size: 12)
          ]
        )
      )
      return modeSwitchButtonTitle
    }
  }
  
  func titleLabelText(_ mode: AuthModuleLaunchMode) -> NSAttributedString {
    switch mode {
    case .signIn:
      return NSAttributedString(
        string: L10n.signInTitleLabelText,
        attributes: [
          .font: FontFamily.Nunito.bold.font(size: 36),
          .foregroundColor: Asset.Colors.white.color
        ]
      )
    case .signUp:
      return NSAttributedString(
        string: L10n.signUpTitleLabelText,
        attributes: [
          .font: FontFamily.Nunito.bold.font(size: 36),
          .foregroundColor: Asset.Colors.white.color
        ]
      )
    }
  }
  
  func subtitleLabelText(_ mode: AuthModuleLaunchMode) -> NSAttributedString {
    switch mode {
    case .signIn:
      return NSAttributedString(
        string: L10n.signInSubtitleLabelText,
        attributes: [
          .font: FontFamily.Nunito.regular.font(size: 17),
          .foregroundColor: Asset.Colors.white.color
        ]
      )
    case .signUp:
      return NSAttributedString(
        string: L10n.signUpSubtitleLabelText,
        attributes: [
          .font: FontFamily.Nunito.regular.font(size: 17),
          .foregroundColor: Asset.Colors.white.color
        ]
      )
    }
  }
  
  func submitButtonTitle(_ mode: AuthModuleLaunchMode) -> NSAttributedString {
    switch mode {
    case .signIn:
      return NSAttributedString(
        string: L10n.signInSubmitButtonText,
        attributes: [
          .font: FontFamily.Nunito.regular.font(size: 17),
          .foregroundColor: Asset.Colors.white.color
        ]
      )
    case .signUp:
      return NSAttributedString(
        string: L10n.signUpSubtitleLabelText,
        attributes: [
          .font: FontFamily.Nunito.regular.font(size: 17),
          .foregroundColor: Asset.Colors.white.color
        ]
      )
    }
  }
  
  func render(_ mode: AuthModuleLaunchMode) {
    modeSwitchButton.setAttributedTitle(switchModeButtonTitle(mode), for: .normal)
    titleLabel.attributedText = titleLabelText(mode)
    subtitleLabel.attributedText = subtitleLabelText(mode)
  }
}

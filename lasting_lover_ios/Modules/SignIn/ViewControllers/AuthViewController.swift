//
//  SignUpViewController.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 01.10.2021.
//

import RxSwift
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
  
  let submitButton = Button(style: .primary, title: "")
  
  let hintLabel = UILabel()
  
  let appleSignUpButton = UIButton()
  
  let modeSwitchButton = UIButton()
  
  private let disposeBag = DisposeBag()
  let viewModel: AuthControllerViewModel
  
  init(viewModel: AuthControllerViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
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
  
  fileprivate func setupAppleSignInButton() {
    appleSignUpButton.snp.makeConstraints { make in
      make.size.equalTo(57)
      make.centerX.equalToSuperview()
      make.bottom.equalTo(modeSwitchButton.snp.top).offset(-24)
    }
    appleSignUpButton.clipsToBounds = true
    appleSignUpButton.layer.borderWidth = 1
    appleSignUpButton.layer.borderColor = Asset.Colors.white.color.withAlphaComponent(0.5).cgColor
    appleSignUpButton.setBackgroundImage(UIImage(color: Asset.Colors.grayTransparent.color), for: .normal)
    appleSignUpButton.setImage(Asset.Images.appleIcon.image, for: .normal)
  }
  
  fileprivate func setupHintLabel() {
    hintLabel.numberOfLines = 0
    hintLabel.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview().inset(16)
      make.bottom.equalTo(appleSignUpButton.snp.top).offset(-32)
    }
    hintLabel.attributedText = NSAttributedString(
      string: L10n.signInHintLabelText,
      attributes: [
        .font: FontFamily.Nunito.regular.font(size: 15),
        .foregroundColor: Asset.Colors.graySolid.color
      ]
    )
  }
  
  fileprivate func setupSubmitButton() {
    submitButton.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview().inset(16)
      make.height.equalTo(56)
    }
  }
  
  fileprivate func setupModeSwitchButton() {
    modeSwitchButton.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview().offset(16)
      make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-28)
    }
  }
  
  fileprivate func setupTextfieldsStackView() {
    textfieldsStackView.spacing = 24
    textfieldsStackView.axis = .vertical
    textfieldsStackView.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview().inset(16)
      make.bottom.equalTo(submitButton.snp.top).offset(-55)
    }
    [mailTextfieldView, passwordTextfieldView].forEach { t in
      textfieldsStackView.addArrangedSubview(t)
      t.snp.makeConstraints { make in
        make.height.equalTo(57)
        make.leading.trailing.equalToSuperview()
      }
    }
    passwordTextfieldView.textfield.isSecureTextEntry = true
  }
  
  fileprivate func setupTitleStackView() {
    titleLabelsStackView.spacing = 16
    titleLabelsStackView.axis = .vertical
    titleLabelsStackView.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview().inset(16)
      make.bottom.equalTo(textfieldsStackView).offset(-32)
    }
    [titleLabel, subtitleLabel].forEach { l in
      titleLabelsStackView.addArrangedSubview(l)
      l.numberOfLines = 0
    }
  }
  
  fileprivate func setupUI() {
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
    setupModeSwitchButton()
    setupAppleSignInButton()
    setupHintLabel()
    setupSubmitButton()
    setupTextfieldsStackView()
    setupTitleStackView()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupUI()
  }
  
  func configure(with viewModel: AuthControllerViewModel) {
    
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
          .foregroundColor: Asset.Colors.white.color,
          .paragraphStyle: NSParagraphStyle.centered
        ]
      )
    case .signUp:
      return NSAttributedString(
        string: L10n.signUpTitleLabelText,
        attributes: [
          .font: FontFamily.Nunito.bold.font(size: 36),
          .foregroundColor: Asset.Colors.white.color,
          .paragraphStyle: NSParagraphStyle.centered
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
          .foregroundColor: Asset.Colors.white.color,
          .paragraphStyle: NSParagraphStyle.centered
        ]
      )
    case .signUp:
      return NSAttributedString(
        string: L10n.signUpSubtitleLabelText,
        attributes: [
          .font: FontFamily.Nunito.regular.font(size: 17),
          .foregroundColor: Asset.Colors.white.color,
          .paragraphStyle: NSParagraphStyle.centered
        ]
      )
    }
  }
  
  func submitButtonTitle(_ mode: AuthModuleLaunchMode) -> String {
    switch mode {
    case .signIn:
      return L10n.signInSubmitButtonText
    case .signUp:
      return L10n.signUpSubtitleLabelText
    }
  }
  
  func render(_ mode: AuthModuleLaunchMode) {
    modeSwitchButton.setAttributedTitle(switchModeButtonTitle(mode), for: .normal)
    titleLabel.attributedText = titleLabelText(mode)
    subtitleLabel.attributedText = subtitleLabelText(mode)
    submitButton.title = submitButtonTitle(mode)
  }
}

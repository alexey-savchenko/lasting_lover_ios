//
//  AuthFInishViewController.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 02.10.2021.
//

import UIKit

class CongratulationsController: ViewController<BackgroundImageView> {
  let imageView = UIImageView()
  let titleLabel = UILabel()
  let subtitleLabel = UILabel()

  let submitButton = Button(style: .primary, title: L10n.buttonNext)

  override func viewDidLoad() {
    super.viewDidLoad()

    [
      imageView,
      titleLabel,
      subtitleLabel,
      submitButton
    ]
    .forEach(view.addSubview)
    imageView.image = Asset.Images.heartsIllustrtion.image
    imageView.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(-30)
      make.trailing.equalToSuperview().offset(30)
      make.top.equalTo(view.safeAreaLayoutGuide).offset(30)
    }

    titleLabel.attributedText = NSAttributedString(
      string: L10n.congratulationsTitle,
      attributes: [
        .font: FontFamily.Nunito.bold.font(size: 36),
        .foregroundColor: Asset.Colors.white.color,
        .paragraphStyle: NSParagraphStyle.centered
      ]
    )
    titleLabel.snp.makeConstraints { make in
      make.top.equalTo(imageView.snp.bottom).offset(40)
      make.leading.trailing.equalToSuperview().inset(16)
    }

    subtitleLabel.attributedText = NSAttributedString(
      string: L10n.congratulationsSubtitle,
      attributes: [
        .font: FontFamily.Nunito.regular.font(size: 17),
        .foregroundColor: Asset.Colors.white.color,
        .paragraphStyle: NSParagraphStyle.centered
      ]
    )
    subtitleLabel.numberOfLines = 0
    subtitleLabel.snp.makeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom).offset(16)
      make.leading.trailing.equalToSuperview().inset(16)
    }

    submitButton.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview().inset(24)
      make.height.equalTo(56)
      make.top.equalTo(subtitleLabel.snp.bottom).offset(32)
    }
  }
}

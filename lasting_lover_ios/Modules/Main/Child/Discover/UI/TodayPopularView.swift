//
//  TodayPopularView.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 06.10.2021.
//

import UIKit
import UNILibCore

class ProgressBarView: UIView {
  
  let titleLabel = UILabel()
  let progressImageView = UIImageView()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  fileprivate func setupTitleLabel() {
    titleLabel.textColor = Asset.Colors.white.color
    titleLabel.font = FontFamily.Nunito.regular.font(size: 15)
    titleLabel.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(16)
      make.centerY.equalToSuperview()
    }
  }
  
  fileprivate func setupProgressImageView() {
    progressImageView.clipsToBounds = true
    progressImageView.layer.cornerRadius = 14
    progressImageView.snp.makeConstraints { make in
      make.bottom.leading.top.equalToSuperview()
      make.width.equalToSuperview().multipliedBy(0)
    }
  }
  
  func setupUI() {
    [progressImageView, titleLabel].forEach(addSubview)
    clipsToBounds = true
    backgroundColor = UIColor(hexString: "F2F3F7").withAlphaComponent(0.15)
    setupProgressImageView()
    setupTitleLabel()
  }
  
  func setProgress(value: Double) {
    progressImageView.snp.remakeConstraints { make in
      make.bottom.leading.top.equalToSuperview()
      make.width.equalToSuperview().multipliedBy(value)
    }
    setNeedsLayout()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    
    progressImageView.layer.cornerRadius = bounds.height / 2
    layer.cornerRadius = bounds.height / 2
    progressImageView.image = horizontalGradientImage(
      size: progressImageView.bounds.size,
      color0: Asset.Colors.tabColor0.color,
      color1: Asset.Colors.tabColor1.color
    )
  }
}

extension ProgressBarView: Snapshotable {
  
  static func make() -> Snapshotable {
    let v = ProgressBarView()
    v.setProgress(value: 0.5)
    v.titleLabel.text = "TEST"
    return v
  }
  
  func layoutIn(context: UIView) {
    snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.leading.trailing.equalToSuperview().inset(16)
      make.height.equalTo(32)
    }
  }
}

class TodayPopularView: UIView {
  
  let titleLabel = UILabel()
  
  let progressBarStackView = UIStackView()
  let progressBar0 = ProgressBarView()
  let progressBar1 = ProgressBarView()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  fileprivate func setupTitleLabel() {
    titleLabel.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview().inset(16)
      make.top.equalToSuperview().offset(16)
    }
    titleLabel.attributedText = NSAttributedString(
      string: L10n.todaysPopular,
      attributes: [.foregroundColor: Asset.Colors.white.color,
                   .font: FontFamily.Nunito.semiBold.font(size: 17)]
    )
  }
  
  fileprivate func setupProgressBarStackView() {
    progressBarStackView.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview().inset(16)
      make.top.equalTo(titleLabel.snp.bottom).offset(16)
      make.bottom.equalToSuperview().offset(-16)
    }
//    progressBarStackView.alignment = .fill
    progressBarStackView.spacing = 8
    progressBarStackView.axis = .vertical
    [progressBar0, progressBar1].forEach { v in
      progressBarStackView.addArrangedSubview(v)
      v.snp.makeConstraints { make in
        make.height.equalTo(42)
      }
    }
  }
  
  func setupUI() {
    backgroundColor = Asset.Colors.tabBarBackground.color
    layer.cornerRadius = 14
    clipsToBounds = true
    [titleLabel, progressBarStackView].forEach(addSubview)
    setupTitleLabel()
    setupProgressBarStackView()
  }
  
}

extension TodayPopularView: Snapshotable {
  static func make() -> Snapshotable {
    let v = TodayPopularView()
    v.progressBar0.setProgress(value: 0.3)
    v.progressBar1.setProgress(value: 0.7)
    v.progressBar0.titleLabel.text = "Josh"
    v.progressBar1.titleLabel.text = "Mike"
    return v
  }
  
  func layoutIn(context: UIView) {
    snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview().inset(16)
      make.centerY.equalToSuperview()
//      make.height.equalTo(142)
    }
  }
}

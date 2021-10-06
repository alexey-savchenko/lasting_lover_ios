//
//  TodayPopularView.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 06.10.2021.
//

import UIKit

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
    layer.cornerRadius = 14
    setupProgressImageView()
    setupTitleLabel()
  }
  
  func setProgress(value: Double) {
    progressImageView.snp.updateConstraints { make in
      make.width.equalToSuperview().multipliedBy(value)
    }
  }
}

class TodayPopularView: UIView {

    

}

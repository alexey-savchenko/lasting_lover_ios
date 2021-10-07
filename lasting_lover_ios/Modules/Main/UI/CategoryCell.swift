//
//  CategoryCell.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 06.10.2021.
//

import UIKit

class CategoryCell: UICollectionViewCell {
  let titleLabel = UILabel()

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
      make.leading.trailing.equalToSuperview().inset(8)
      make.centerY.equalToSuperview()
    }
  }

  fileprivate func setupContentView() {
    contentView.backgroundColor = Asset.Colors.tabBarBackground.color
    contentView.clipsToBounds = true
    contentView.layer.cornerRadius = 14
    contentView.addSubview(titleLabel)
  }

  func setupUI() {
    setupContentView()
    setupTitleLabel()
  }
}

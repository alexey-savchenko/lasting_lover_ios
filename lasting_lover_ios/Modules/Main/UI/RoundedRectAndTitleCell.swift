//
//  RoundedRectAndTitleCell.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 06.10.2021.
//

import UIKit
import UNILibCore
import RxSwift

protocol RoundedRectAndTitleSubtitleCellViewModel {
  var image: Observable<UIImage> { get }
  var title: String { get }
  var subtitle: String { get }
  var shouldDisplayPlayImage: Bool { get }
  var shouldDisplayAccessoryView: Bool { get }
  var shouldDisplayCherryView: Bool { get }
}

class RoundedRectAndTitleSubtitleCell: UICollectionViewCell {
  
  let imageView = UIImageView()
  let titleLabel = UILabel()
  let subtitleLabel = UILabel()
  
  let cherryImageView = UIImageView(image: Asset.Images.cherries.image)
  let playImageView = UIImageView(image: Asset.Images.playInWhiteCircle.image)
  let topLeftAccesoryLabel = InsetLabel()
  
  var viewModel: RoundedRectAndTitleSubtitleCellViewModel?
  
  var disposeBag = DisposeBag()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configure(with viewModel: RoundedRectAndTitleSubtitleCellViewModel) {
    self.viewModel = viewModel
    viewModel.image
      .map(Optional.init)
      .subscribe(imageView.rx.image)
      .disposed(by: disposeBag)
    titleLabel.text = viewModel.title
    subtitleLabel.text = viewModel.subtitle
    topLeftAccesoryLabel.isHidden = !viewModel.shouldDisplayAccessoryView
    playImageView.isHidden = !viewModel.shouldDisplayPlayImage
    cherryImageView.isHidden = !viewModel.shouldDisplayCherryView
  }
  
  fileprivate func setupImageView() {
    imageView.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview()
      make.height.equalTo(164)
      make.top.equalToSuperview()
    }
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    imageView.layer.cornerRadius = 14
    imageView.layer.borderWidth = 1
    imageView.layer.borderColor = Asset.Colors.white.color.withAlphaComponent(0.5).cgColor
  }
  
  fileprivate func setupTitleLabel() {
    titleLabel.textColor = Asset.Colors.white.color
    titleLabel.font = FontFamily.Nunito.semiBold.font(size: 17)
    titleLabel.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(4)
      make.trailing.equalToSuperview().offset(-20)
      make.top.equalTo(imageView.snp.bottom).offset(-8)
    }
  }
  
  fileprivate func setupSubtitleLabel() {
    subtitleLabel.textColor = Asset.Colors.white.color.withAlphaComponent(0.8)
    subtitleLabel.font = FontFamily.Nunito.regular.font(size: 15)
    subtitleLabel.numberOfLines = 2
    subtitleLabel.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview().inset(4)
      make.top.equalTo(titleLabel.snp.bottom).offset(8)
    }
  }
  
  fileprivate func setupCherryImageView() {
    cherryImageView.snp.makeConstraints { make in
      make.size.equalTo(18)
      make.trailing.equalToSuperview()
      make.bottom.equalTo(titleLabel)
    }
  }
  
  fileprivate func setupPlayImageView() {
    playImageView.snp.makeConstraints { make in
      make.center.equalTo(imageView)
      make.size.equalTo(40)
    }
  }
  
  fileprivate func setupAccesoryLabel() {
    topLeftAccesoryLabel.layer.cornerRadius = 14
    topLeftAccesoryLabel.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMinYCorner]
    topLeftAccesoryLabel.clipsToBounds = true
    topLeftAccesoryLabel.snp.makeConstraints { make in
      make.leading.equalToSuperview()
      make.top.equalToSuperview()
      make.height.equalTo(22)
    }
  }
  
  private func setupUI() {
    [
      imageView,
      titleLabel,
      subtitleLabel,
      cherryImageView,
      playImageView,
      topLeftAccesoryLabel
    ].forEach(contentView.addSubview)
    
    setupImageView()
    setupTitleLabel()
    setupSubtitleLabel()
    setupCherryImageView()
    setupPlayImageView()
    setupAccesoryLabel()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    topLeftAccesoryLabel.backgroundColor = UIColor(
      patternImage: horizontalGradientImage(
        size: topLeftAccesoryLabel.bounds.size,
        color0: Asset.Colors.tabColor0.color,
        color1: Asset.Colors.tabColor1.color
      )
    )
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    
    disposeBag = DisposeBag()
  }
}

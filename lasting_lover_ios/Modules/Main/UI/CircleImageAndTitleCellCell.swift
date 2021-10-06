//
//  CircleImageAndTitleCellCell.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 06.10.2021.
//

import UIKit
import RxSwift

protocol CircleImageAndTitleCellCellViewModel {
  var image: Observable<UIImage> { get }
  var title: String { get }
}

class CircleImageAndTitleCellCell: UICollectionViewCell {
    
  let imageView = UIImageView()
  let titleLabel = UILabel()
  
  var viewModel: CircleImageAndTitleCellCellViewModel?
  
  private var disposeBag = DisposeBag()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configure(with viewModel: CircleImageAndTitleCellCellViewModel) {
    self.viewModel = viewModel
    viewModel.image
      .map(Optional.init)
      .subscribe(imageView.rx.image)
      .disposed(by: disposeBag)
    titleLabel.text = viewModel.title
  }
  
  fileprivate func setupImageView() {
    imageView.snp.makeConstraints { make in
      make.size.equalTo(72)
      make.centerX.equalToSuperview()
      make.top.equalToSuperview()
    }
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    imageView.layer.cornerRadius = 36
  }
  
  fileprivate func setupTitleLabel() {
    titleLabel.textColor = Asset.Colors.white.color
    titleLabel.font = FontFamily.Nunito.semiBold.font(size: 17)
    titleLabel.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview().inset(4)
      make.top.equalTo(imageView.snp.bottom).offset(-8)
    }
  }
  
  private func setupUI() {
    [imageView, titleLabel].forEach(contentView.addSubview)
    setupImageView()
    setupTitleLabel()
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    
    disposeBag = DisposeBag()
  }
}

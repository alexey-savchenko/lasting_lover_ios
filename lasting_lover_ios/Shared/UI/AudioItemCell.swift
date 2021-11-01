//
//  AudioItemCell.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 30.10.2021.
//

import UIKit
import RxSwift

class AudioItemCell: UICollectionViewCell {
  enum PlayButtonState: Int, Hashable {
    case readyToPlay
    case locked
    case played
  }
  
  open func setPlayButtonState(_ value: AudioItemCell.PlayButtonState) {
    
  }
}

class AudioItemCell_1: AudioItemCell {
  
  private var disposeBag = DisposeBag()
  
  let playButton = UIButton()
  
  let titleLabel = UILabel()
  let durationLabel = UILabel()
  let accessoryLabel = UILabel()
  
  let moreButton = UIButton()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupUI() {
    [titleLabel, durationLabel, accessoryLabel, moreButton, playButton].forEach(contentView.addSubview)
    playButton.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.leading.equalToSuperview().offset(8)
      make.size.equalTo(52)
    }
    
    titleLabel.snp.makeConstraints { make in
      make.top.equalTo(playButton).offset(2)
      make.leading.equalTo(playButton.snp.trailing).offset(18)
      make.trailing.equalToSuperview().offset(-16)
    }
    
    durationLabel.snp.makeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom).offset(6)
      make.leading.equalTo(playButton.snp.trailing).offset(18)
    }
    
    accessoryLabel.snp.makeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom).offset(6)
      make.leading.equalTo(durationLabel.snp.trailing).offset(12)
    }
    
    moreButton.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.trailing.equalToSuperview().offset(-8)
      make.size.equalTo(44)
    }
  }
  
  override func setPlayButtonState(_ value: AudioItemCell.PlayButtonState) {
    
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    
    disposeBag = DisposeBag()
  }
}

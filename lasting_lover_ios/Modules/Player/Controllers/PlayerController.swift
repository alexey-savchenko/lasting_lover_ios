//
//  PlayerController.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 07.10.2021.
//

import UIKit
import RxSwift

class PlayerController: ViewController<BackgroundImageView> {
  
  let navbar = BackButtonNavbarView()
  
  let artworkImageView = UIImageView()
  let titleLabel = UILabel()
  let authorLabel = UILabel()
  let progressBarView = PlayerProgressBarView()
  let currentTimeLabel = UILabel()
  let durationLabel = UILabel()
  
  let playbackControlsStackView = UIStackView()
  let playButton = UIButton()
  let bwdSeekButton = UIButton()
  let fwdSeekButton = UIButton()
  
  let viewModel: PlayerControllerViewModel
  private let disposeBag = DisposeBag()
  
  init(viewModel: PlayerControllerViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupUI()
    configure(with: viewModel)
  }
  
  private func setupUI() {
    [navbar,
     artworkImageView,
     titleLabel,
     authorLabel,
     progressBarView,
     currentTimeLabel,
     durationLabel,
     playbackControlsStackView].forEach(view.addSubview)
    
    navbar.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview()
      make.top.equalTo(view.safeAreaLayoutGuide)
      make.height.equalTo(44)
    }
    
    artworkImageView.clipsToBounds = true
    artworkImageView.snp.makeConstraints { make in
      make.size.equalTo(UIScreen.main.bounds.height * 0.33)
      make.centerX.equalToSuperview()
      make.top.equalTo(navbar.snp.bottom).offset(14)
    }
    titleLabel.font = FontFamily.Nunito.bold.font(size: 36)
    titleLabel.textColor = .white
    titleLabel.textAlignment = .center
    titleLabel.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalTo(artworkImageView.snp.bottom).offset(18)
      make.leading.trailing.equalToSuperview().inset(16)
    }
    authorLabel.font = FontFamily.Nunito.semiBold.font(size: 17)
    authorLabel.textColor = .white
    authorLabel.textAlignment = .center
    authorLabel.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalTo(titleLabel.snp.bottom).offset(8)
      make.leading.trailing.equalToSuperview().inset(16)
    }
    
    progressBarView.snp.makeConstraints { make in
      make.top.equalTo(authorLabel.snp.bottom).offset(60)
      make.height.equalTo(20)
      make.leading.trailing.equalToSuperview().inset(30)
    }

    currentTimeLabel.font = FontFamily.Nunito.regular.font(size: 14)
    currentTimeLabel.textColor = .white
    currentTimeLabel.snp.makeConstraints { make in
      make.leading.equalTo(progressBarView)
      make.top.equalTo(progressBarView.snp.bottom).offset(5)
    }
    
    durationLabel.font = FontFamily.Nunito.regular.font(size: 14)
    durationLabel.textColor = .white
    durationLabel.snp.makeConstraints { make in
      make.trailing.equalTo(progressBarView)
      make.top.equalTo(progressBarView.snp.bottom).offset(5)
    }
    
    playbackControlsStackView.alignment = .center
    playbackControlsStackView.axis = .horizontal
    playbackControlsStackView.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview().inset(45)
			if UIScreen.main.bounds.height >= 667 {
				make.top.equalTo(progressBarView.snp.bottom).offset(50)
			} else {
				make.top.equalTo(progressBarView.snp.bottom).offset(30)
			}
		
      make.height.equalTo(110)
    }
    [bwdSeekButton, playButton, fwdSeekButton].forEach(playbackControlsStackView.addArrangedSubview)
    
    bwdSeekButton.setImage(Asset.Images.bcwd.image, for: .normal)
    bwdSeekButton.snp.makeConstraints { make in
      make.size.equalTo(40)
    }
    
    fwdSeekButton.setImage(Asset.Images.fwd.image, for: .normal)
    fwdSeekButton.snp.makeConstraints { make in
      make.size.equalTo(40)
    }
    
    playButton.setImage(Asset.Images.playerPlayButton.image, for: .normal)
    playButton.snp.makeConstraints { make in
      make.size.equalTo(110)
    }
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    artworkImageView.layer.cornerRadius = artworkImageView.bounds.height / 2
  }
  
  private func configure(with viewModel: PlayerControllerViewModel) {
    viewModel.output.playbackProgress
      .bind { [weak self] value in
        self?.progressBarView.setProgress(value)
      }
      .disposed(by: disposeBag)
    progressBarView.seekToProgress
      .subscribe(viewModel.input.seekToProgress)
      .disposed(by: disposeBag)
    fwdSeekButton.rx.tap
      .subscribe(viewModel.input.fwdTap)
      .disposed(by: disposeBag)
    bwdSeekButton.rx.tap
      .subscribe(viewModel.input.bcwdTap)
      .disposed(by: disposeBag)
    viewModel.output.title
      .map(Optional.init)
      .subscribe(titleLabel.rx.text)
      .disposed(by: disposeBag)
    viewModel.output.author
      .map(Optional.init)
      .subscribe(authorLabel.rx.text)
      .disposed(by: disposeBag)
    playButton.rx.tap
      .subscribe(viewModel.input.playTap)
      .disposed(by: disposeBag)
    viewModel.output.isPlaying
      .bind { [weak self] value in
        if value {
          self?.playButton.setImage(Asset.Images.playerPauseButton.image, for: .normal)
        } else {
          self?.playButton.setImage(Asset.Images.playerPlayButton.image, for: .normal)
        }
    }
    .disposed(by: disposeBag)
    viewModel.output.image
      .map(Optional.init)
      .subscribe(artworkImageView.rx.image)
      .disposed(by: disposeBag)
    viewModel.output.isFavorite
      .bind { [unowned navbar] value in
        if value {
          navbar.setRightButtonImage(Asset.Images.heartFilled.image.tinted(Asset.Colors.white.color))
        } else {
          navbar.setRightButtonImage(Asset.Images.heart.image.tinted(Asset.Colors.white.color))
        }
      }
      .disposed(by: disposeBag)
    
    navbar.rightButton.rx.tap
      .subscribe(viewModel.input.favoriteTap)
      .disposed(by: disposeBag)
    viewModel.output.title
      .bind { [unowned navbar] value in
        navbar.setTitle(
          NSAttributedString(
            string: value,
            attributes: [
              .font: FontFamily.Nunito.bold.font(size: 17),
              .foregroundColor: Asset.Colors.white.color,
              .paragraphStyle: NSParagraphStyle.centered
            ]
          )
        )
      }
      .disposed(by: disposeBag)
  }
}

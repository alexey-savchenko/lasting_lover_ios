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
     playButton,
     bwdSeekButton,
     fwdSeekButton].forEach(view.addSubview)
    
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
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    artworkImageView.layer.cornerRadius = artworkImageView.bounds.height / 2
  }
  
  private func configure(with viewModel: PlayerControllerViewModel) {
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

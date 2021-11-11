//
//  AudioItemCell.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 30.10.2021.
//

import UIKit
import RxSwift

enum PlayButtonState: Int, Hashable {
	case readyToPlay
	case locked
	case played
}

class AudioItemCell: UICollectionViewCell {

  
  open func setPlayButtonState(_ value: PlayButtonState) {
    
  }
}

class StoryCellViewModel {
	
	struct Input {
		
	}
	
	struct Output {
		let state: Observable<PlayButtonState>
		let title: String
		let duration: String
	}
	
	let input: Input
	let output: Output
	let story: Story
	
	init(story: Story) {
		self.story = story
		self.input = Input()
		self.output = Output(
			state: Observable
				.combineLatest(
					Current.subscriptionService().subscriptionActiveObservable,
					Current.listentedItemsService().hadListened(story.id)
				)
				.map { subActive, hadListened in
					return subActive ? (hadListened ? .played : .readyToPlay) : .locked
				},
			title: story.name,
			duration: "6 min"
		)
	}
}

class StoryCell: AudioItemCell {
	
	private var disposeBag = DisposeBag()
	
	let playButton = UIButton()
	
	let titleLabel = UILabel()
	let durationLabel = UILabel()
	let accessoryLabel = UILabel()
	
	let moreButton = UIButton()
	
	weak var viewModel: StoryCellViewModel?
	
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupUI() {
		contentView.clipsToBounds = true
		contentView.layer.cornerRadius = 14
		contentView.backgroundColor = UIColor(red: 32.0 / 255.0, green: 14.0 / 255.0, blue: 42.0 / 255.0, alpha: 1)
    [titleLabel, durationLabel, accessoryLabel, moreButton, playButton].forEach(contentView.addSubview)
    playButton.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.leading.equalToSuperview().offset(16)
      make.size.equalTo(40)
    }
    
		titleLabel.textColor = .white
		titleLabel.font = FontFamily.Nunito.semiBold.font(size: 17)
    titleLabel.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(10)
      make.leading.equalTo(playButton.snp.trailing).offset(18)
      make.trailing.equalToSuperview().offset(-16)
    }
    
		durationLabel.textColor = .white
		durationLabel.font = FontFamily.Nunito.regular.font(size: 15)
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
	
	func configure(with viewModel: StoryCellViewModel) {
		viewModel.output.state
			.bind { [weak self] value in
				self?.setPlayButtonState(value)
			}
			.disposed(by: disposeBag)
		titleLabel.text = viewModel.output.title
		durationLabel.text = viewModel.output.duration
	}
  
  override func setPlayButtonState(_ value: PlayButtonState) {
		switch value {
		case .locked: playButton.setImage(Asset.Images.storyCellLocked.image, for: .normal)
		case .played: playButton.setImage(Asset.Images.storyCellPlayed.image, for: .normal)
		case .readyToPlay: playButton.setImage(Asset.Images.storyCellPlay.image, for: .normal)
		}
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    
    disposeBag = DisposeBag()
  }
}

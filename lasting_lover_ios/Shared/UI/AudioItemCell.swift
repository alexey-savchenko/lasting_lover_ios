//
//  AudioItemCell.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 30.10.2021.
//

import UIKit
import RxSwift
import UNILibCore

enum PlayButtonState: Int, Hashable {
	case readyToPlay
	case locked
	case played
}

class AudioItemCell: UICollectionViewCell {
	open func setPlayButtonState(_ value: PlayButtonState) {
		
	}
}

class StoryCellViewModel: Hashable {
	func hash(into hasher: inout Hasher) {
		hasher.combine(story)
	}
	
	static func == (lhs: StoryCellViewModel, rhs: StoryCellViewModel) -> Bool {
		return lhs.story == rhs.story
	}
	
	struct Input {
		let deleteItem: AnyObserver<Void>
	}
	
	private let deleteItemSubject = PublishSubject<Void>()
	
	struct Output {
		let state: Observable<PlayButtonState>
		let title: String
		let duration: String
		let deleteItem: Observable<Story>
	}
	
	let input: Input
	let output: Output
	let story: Story
	
	init(story: Story) {
		self.story = story
		self.input = Input(
			deleteItem: deleteItemSubject.asObserver()
		)
		self.output = Output(
			state: Observable
				.combineLatest(
					Current.subscriptionService().subscriptionActiveObservable,
					Current.listentedItemsService().hadListened(story.id)
				)
				.map { subActive, hadListened in
					if story.paid == 1 {
						return subActive ? (hadListened ? .played : .readyToPlay) : .locked
					} else {
						return hadListened ? .played : .readyToPlay
					}
				},
			title: story.name,
			duration: "\(Int(story.audioDuration / 60)) min",
			deleteItem: deleteItemSubject.map { story }
		)
	}
	
	deinit {
		print("\(self) deinit")
	}
}

class StoryCell: AudioItemCell {
	
	fileprivate var disposeBag = DisposeBag()
	
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
	
	func setupUI() {
		defer {
			contentView.subviews.forEach { $0.isUserInteractionEnabled = false }
		}
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
		self.viewModel = viewModel
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

class SwipeableStoryCell: StoryCell {
	
	let swipeGesture = UISwipeGestureRecognizer(target: nil, action: nil)
	
	override func setupUI() {
		super.setupUI()
		
		contentView.addGestureRecognizer(swipeGesture)
		swipeGesture.direction = .left
	}
	
	override func configure(with viewModel: StoryCellViewModel) {
		super.configure(with: viewModel)
		
		swipeGesture.rx.event
			.do(onNext: { [weak self] _ in
				guard let self = self else { return }
				let anim = CABasicAnimation(keyPath: #keyPath(CALayer.transform))
				anim.fromValue = CATransform3DIdentity
				anim.toValue = CATransform3DMakeTranslation(-self.contentView.bounds.width - 100, 0, 0)
				anim.duration = 0.5
				anim.isRemovedOnCompletion = false
				anim.fillMode = .forwards
				self.contentView.layer.add(anim, forKey: "transformAnimation")
			})
			.delay(.milliseconds(500), scheduler: MainScheduler.instance)
				.map(toVoid)
				.subscribe(viewModel.input.deleteItem)
				.disposed(by: disposeBag)
				}
}

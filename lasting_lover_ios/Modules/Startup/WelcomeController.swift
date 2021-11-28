//
//  WelcomeController.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 28.11.2021.
//

import Foundation
import UIKit
import RxSwift
import RxRelay
import UNILibCore

class WelcomeController: ViewController<BackgroundImageView> {
	
	enum Stage {
		case welcome
		case prePurhcase
		case finish
	}
	
	private let presentPurchaseScreenSubject = PublishSubject<Void>()
	var presentPurchaseScreen: Observable<Void> {
		return presentPurchaseScreenSubject.asObservable()
	}
	
	private let finishFlowSubject = PublishSubject<Void>()
	var finishFlow: Observable<Void> {
		return finishFlowSubject.asObservable()
	}

	private let disposeBag = DisposeBag()
	
	let titleImageView = UIImageView()
	
	let labelStackView = UIStackView()
	let titleLabel = UILabel()
	let subtitleLabel = UILabel()
	
	let button = Button(style: .primary, title: L10n.welcomeProceed)
	
	let stageSubject = BehaviorRelay(value: WelcomeController.Stage.welcome)
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupUI()
		bind()
	}
	
	private func setupUI() {
		[titleImageView, labelStackView, button].forEach(view.addSubview)
		button.snp.makeConstraints { make in
			make.centerX.equalToSuperview()
			make.leading.trailing.equalToSuperview().inset(24)
			make.height.equalTo(56)
			make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-110)
		}
		
		labelStackView.axis = .vertical
		labelStackView.spacing = 16
		
		[titleLabel, subtitleLabel].forEach(labelStackView.addArrangedSubview)
		
		labelStackView.snp.makeConstraints { make in
			make.leading.trailing.equalToSuperview().inset(24)
			make.bottom.equalTo(button.snp.top).offset(-56)
		}
		
		titleLabel.textAlignment = .center
		titleLabel.font = FontFamily.Nunito.bold.font(size: 36)
		titleLabel.textColor = .white
		titleLabel.numberOfLines = 0
		subtitleLabel.textAlignment = .center
		subtitleLabel.font = FontFamily.Nunito.semiBold.font(size: 17)
		subtitleLabel.textColor = .white.withAlphaComponent(0.5)
		
		titleImageView.snp.makeConstraints { make in
			make.top.leading.trailing.equalToSuperview()
			make.bottom.equalTo(labelStackView.snp.top)
		}
	}
	
	private func bind() {

		button.rx.tap
			.withLatestFrom(stageSubject)
			.bind { [unowned self] value in
				switch value {
				case .welcome:
					self.stageSubject.accept(.prePurhcase)
				case .prePurhcase:
					self.presentPurchaseScreenSubject.onNext(Void())
				case .finish:
					self.finishFlowSubject.onNext(Void())
				}
			}
			.disposed(by: disposeBag)
		
		stageSubject
			.bind { [unowned self] stage in
				UIView.animate(withDuration: 0.2, delay: 0, options: .transitionCrossDissolve) {
					switch stage {
						
					case .finish:
						self.subtitleLabel.isHidden = true
						self.titleLabel.text =  L10n.welcomeStage2Title
						self.titleImageView.image = Asset.Images.welcomeFinishArtwork.image
					case .prePurhcase:
						self.subtitleLabel.isHidden = true
						self.titleLabel.text =  L10n.welcomeStage1Title
						self.titleImageView.image = Asset.Images.welcomePrepurchaseArtwork.image
					case .welcome:
						self.titleLabel.text =  L10n.welcomeStage0Title
						self.subtitleLabel.text =  L10n.welcomeStage0Subtitle
						self.titleImageView.image = Asset.Images.welcomeWelcomeArtwork.image
					}
				}
		}
			.disposed(by: disposeBag)
	}
}

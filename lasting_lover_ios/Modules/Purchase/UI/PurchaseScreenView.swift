//
//  PurchaseScreenView.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 25.11.2021.
//

import Foundation
import RxSwift
import UIKit
import SnapKit

class StarterPurchaseScreenView: UIView, PurchaseScreenViewProtocol, Snapshotable {
	
	private let backgroundImageView = BackgroundImageView(frame: .zero)
	private let topArtworkImageView = UIImageView(image: Asset.Images.starterPurchaseScreenTopArtwork.image)
	private let dismissButton = UIButton()
	
	private let contentStackView = UIStackView()
	
	private let titleLabel = UILabel()
	private let benefitsStackView = UIStackView()
	
	private let benefit1StackView = UIStackView()
	private let benefit1ImageView = UIImageView()
	private let benefit1Label = UILabel()
	
	private let benefit2StackView = UIStackView()
	private let benefit2ImageView = UIImageView()
	private let benefit2Label = UILabel()
	
	private let benefit3StackView = UIStackView()
	private let benefit3ImageView = UIImageView()
	private let benefit3Label = UILabel()
	
	let option2ViewAccesoryImageView = UIImageView()
	let option2ViewAccesoryLabel = UILabel()
	
	private let IAPOptionsStackView = UIStackView()
	let option1View = StarterIAPOptionView(
		periodString: "1 \(L10n.month)",
		priceString: "$15.99",
		iap: .cherrie_1_month_15_99
	)
	let option2View = StarterIAPOptionView(
		periodString: "12 \(L10n.monthPlural)",
		priceString: "$99.99",
		iap: .cherrie_12_month_99_99
	)
	
	private let purchaseButton = Button(
		style: .primary,
		title: L10n.purchaseTryFreeAndSubscribe
	)
	
	let policyStackView = UIStackView()
	let termsOfUseButton = UIButton()
	let separatorLabel = UILabel()
	let privacyPolicyButton = UIButton()
	
	private let selectedIAPTapSubject = ReplaySubject<IAP>.createUnbounded()
	var selectedIAPTap: Observable<IAP> {
		return selectedIAPTapSubject.asObservable()
	}
	
	var selectedIAP: AnyObserver<IAP> {
		return selectedIAPTapSubject.asObserver()
	}
	
	private let purchaseTapSubject = PublishSubject<Void>()
	var purchaseTap: Observable<Void> {
		return purchaseTapSubject.asObservable()
	}
	
	private let dismissTapSubject = PublishSubject<Void>()
	var dismissTap: Observable<Void> {
		return dismissTapSubject.asObservable()
	}
	
	private let restoreTapSubject = PublishSubject<Void>()
	var restoreTap: Observable<Void> {
		return restoreTapSubject.asObservable()
	}
	
	private let policyTapSubject = PublishSubject<Policy>()
	var policyTap: Observable<Policy> {
		return policyTapSubject.asObservable()
	}
	
	private let disposeBag = DisposeBag()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		setupUI()
		bind()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setupUI() {
		[
			backgroundImageView,
			topArtworkImageView,
			dismissButton,
			contentStackView,
			option2ViewAccesoryImageView,
			option2ViewAccesoryLabel
		]
			.forEach(addSubview)
		
		backgroundImageView.snp.makeConstraints { make in
			make.edges.equalToSuperview()
		}
		
		topArtworkImageView.snp.makeConstraints { make in
			make.leading.trailing.top.equalToSuperview()
//			make.height.equalToSuperview().multipliedBy(0.3)
		}
		
		dismissButton.setImage(Asset.Images.close.image.tinted(.white), for: .normal)
		dismissButton.snp.makeConstraints { make in
			make.leading.equalToSuperview().offset(12)
			make.top.equalTo(safeAreaLayoutGuide).offset(12)
			make.size.equalTo(44)
		}
		
		contentStackView.axis = .vertical
		contentStackView.alignment = .center
		contentStackView.distribution = .equalSpacing
		contentStackView.snp.makeConstraints { make in
			make.leading.trailing.equalToSuperview()
			make.top.equalTo(topArtworkImageView.snp.bottom).offset(8)
			make.bottom.equalTo(safeAreaLayoutGuide)
		}
		
		[
			titleLabel,
			benefitsStackView,
			IAPOptionsStackView,
			purchaseButton,
			policyStackView
		]
			.forEach(contentStackView.addArrangedSubview)
		
		titleLabel.numberOfLines = 0
		titleLabel.attributedText = NSAttributedString(
			string: L10n.purchaseThePleasureYouVeBeenWaitingFor,
			attributes: [
				.foregroundColor: UIColor.white,
				.font: FontFamily.Nunito.semiBold.font(size: 22),
				.paragraphStyle: NSParagraphStyle.centered
			]
		)
		titleLabel.snp.makeConstraints { make in
			make.leading.trailing.equalToSuperview().inset(24)
		}
		
		purchaseButton.snp.makeConstraints { make in
			make.leading.trailing.equalToSuperview().inset(24)
			make.height.equalTo(56)
		}
		
		benefitsStackView.axis = .vertical
		benefitsStackView.spacing = 10
		benefitsStackView.snp.makeConstraints { make in
			make.leading.trailing.equalToSuperview().inset(24)
		}
		
		[
			(benefit1StackView,
			 benefit1ImageView,
			 benefit1Label,
			 Asset.Images.check.image,
			 L10n.purchase100StoriesWithNewReleasesEveryWeekForYou),
			(benefit2StackView,
			 benefit2ImageView,
			 benefit2Label,
			 Asset.Images.check.image,
			 L10n.purchaseHotAndHeavyStraightAndQueerDiverseThemes),
			(benefit3StackView,
			 benefit3ImageView,
			 benefit3Label,
			 Asset.Images.check.image,
			 L10n.purchaseSoothingBedtimeStoriesAndWellnessSessions)
		]
			.forEach(setupBenefitStackView)
		
		[benefit1StackView, benefit2StackView, benefit3StackView]
			.forEach(benefitsStackView.addArrangedSubview)
		
		IAPOptionsStackView.axis = .vertical
		IAPOptionsStackView.spacing = 16
		
		IAPOptionsStackView.snp.makeConstraints { make in
			make.leading.trailing.equalToSuperview().inset(24)
		}
		
		[option1View, option2View].forEach { v in
			IAPOptionsStackView.addArrangedSubview(v)
			v.snp.makeConstraints { make in
				make.height.equalTo(62)
			}
		}
		
		option1View.render(state: .selected)
		selectedIAPTapSubject.onNext(option1View.iap)
		
		option2ViewAccesoryImageView.clipsToBounds = true
		option2ViewAccesoryImageView.layer.cornerRadius = 14
		option2ViewAccesoryImageView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMinYCorner]
		option2ViewAccesoryImageView.image = horizontalGradientImage(
			size: CGSize(width: 50, height: 22),
			color0: Asset.Colors.tabColor0.color,
			color1: Asset.Colors.tabColor1.color
		)
		
		option2ViewAccesoryLabel.attributedText = NSAttributedString(
			string: L10n.purchasePopular,
			attributes: [
				.foregroundColor: Asset.Colors.text.color,
				.paragraphStyle: NSParagraphStyle.centered,
				.font: FontFamily.Nunito.semiBold.font(size: 12)
			]
		)
		option2ViewAccesoryLabel.snp.makeConstraints { make in
			make.centerY.equalTo(option2View.snp.top)
			make.leading.equalTo(option2View)
			make.width.equalTo(72)
		}
		
		option2ViewAccesoryImageView.snp.makeConstraints { make in
			make.edges.equalTo(option2ViewAccesoryLabel)
		}
		
		[termsOfUseButton, separatorLabel, privacyPolicyButton]
			.forEach(policyStackView.addArrangedSubview)
		
		policyStackView.axis = .horizontal
		policyStackView.spacing = 5
		
		termsOfUseButton.setAttributedTitle(
			NSAttributedString(
				string: L10n.termsOfUse,
				attributes: [
					.foregroundColor: UIColor.white,
					.font: FontFamily.Nunito.regular.font(size: 12)
				]
			),
			for: .normal
		)
		separatorLabel.attributedText = NSAttributedString(
			string: "/",
			 attributes: [
				 .foregroundColor: UIColor.white,
				 .font: FontFamily.Nunito.regular.font(size: 12)
			 ]
		 )
		privacyPolicyButton.setAttributedTitle(
			NSAttributedString(
				string: L10n.settingsPrivacyPolicy,
				attributes: [
					.foregroundColor: UIColor.white,
					.font: FontFamily.Nunito.regular.font(size: 12)
				]
			),
			for: .normal
		)
	}
	
	private func setupBenefitStackView(
		_ stack: UIStackView,
		imageView: UIImageView,
		label: UILabel,
		image: UIImage,
		text: String
	) {
		
		stack.axis = .horizontal
		stack.spacing = 16
		stack.alignment = .center
		label.numberOfLines = 0
		label.attributedText = NSAttributedString(
			string: text,
			attributes: [
				.foregroundColor: UIColor.white,
				.font: FontFamily.Nunito.regular.font(size: 15)
			]
		)
		imageView.image = image
		imageView.snp.makeConstraints { make in
			make.size.equalTo(24)
		}
		
		[imageView, label].forEach(stack.addArrangedSubview)
		
	}
	
	private func bind() {
		purchaseButton.rx.tap
			.subscribe(purchaseTapSubject)
			.disposed(by: disposeBag)
		dismissButton.rx.tap
			.subscribe(dismissTapSubject)
			.disposed(by: disposeBag)
		Observable
			.merge([option1View.tap, option2View.tap])
			.subscribe(selectedIAPTapSubject)
			.disposed(by: disposeBag)
		selectedIAPTapSubject
			.bind { [unowned self] value in
				[option1View, option2View]
					.forEach { v in
						v.render(state: value == v.iap ? .selected : .`default`)
					}
			}
			.disposed(by: disposeBag)
		Observable
			.merge(
				[
					termsOfUseButton.rx.tap.map { Policy.termsOfUse },
					privacyPolicyButton.rx.tap.map { Policy.privacyPolicy }
				]
			)
			.subscribe(policyTapSubject)
			.disposed(by: disposeBag)
	}
	
	func layoutIn(_ view: UIView) {
		snp.makeConstraints { make in
			make.edges.equalToSuperview()
		}
	}
}

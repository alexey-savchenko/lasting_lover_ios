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

protocol PurchaseScreenViewProtocol: UIView {
	var selectedIAP: Observable<IAP> { get }
	var purchaseTap: Observable<Void> { get }
	var restoreTap: Observable<Void> { get }
	var dismissTap: Observable<Void> { get }
}

class StarterPurchaseScreenView: UIView, PurchaseScreenViewProtocol, Snapshotable {
	
	let backgroundImageView = BackgroundImageView(frame: .zero)
	let topArtworkImageView = UIImageView(image: Asset.Images.starterPurchaseScreenTopArtwork.image)
	let dismissButton = UIButton()
	
	let contentStackView = UIStackView()
	
	let titleLabel = UILabel()
	let benefitsStackView = UIStackView()
	
	let IAPOptionsStackView = UIStackView()
	
	let purchaseButton = Button(
		style: .primary,
		title: L10n.purchaseTryFreeAndSubscribe
	)
	
	let policyTextView = UITextView()
	
	var selectedIAP: Observable<IAP> {
		return .never()
	}
	
	var purchaseTap: Observable<Void> {
		return .never()
	}
	
	var dismissTap: Observable<Void> {
		return .never()
	}
	
	var restoreTap: Observable<Void> {
		return .never()
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		setupUI()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setupUI() {
		[
			backgroundImageView,
			topArtworkImageView,
			dismissButton,
			contentStackView
		]
			.forEach(addSubview)
		
		backgroundImageView.snp.makeConstraints { make in
			make.edges.equalToSuperview()
		}
		
		topArtworkImageView.snp.makeConstraints { make in
			make.leading.trailing.top.equalToSuperview()
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
		
		[titleLabel,
		 benefitsStackView,
		 IAPOptionsStackView,
		 purchaseButton,
		 policyTextView]
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
	}
	
	func layoutIn(_ view: UIView) {
		snp.makeConstraints { make in
			make.edges.equalToSuperview()
		}
	}
}

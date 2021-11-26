//
//  StarterIAPOptionView.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 26.11.2021.
//

import UIKit
import RxSwift

class StarterIAPOptionView: UIButton {
	
	enum State {
		case `default`
		case selected
	}

	let periodLabel = UILabel()
	
	let rightStackView = UIStackView()
	let priceLabel = UILabel()
	let selectionIndicatorImageView = UIImageView()
	
	let iap: IAP
	
	lazy var tap: Observable<IAP> = {
		return rx.tap.map { [weak self] _ in
			return self?.iap
		}
		.filterNil()
	}()
	
	init(
		periodString: String,
		priceString: String,
		iap: IAP
	) {
		self.iap = iap
		super.init(frame: .zero)
		
		periodLabel.text = periodString
		priceLabel.text = priceString
		
		setupUI()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setupUI() {
		defer {
			render(state: .default)
			subviews.forEach { $0.isUserInteractionEnabled = false }
		}
		
		clipsToBounds = true
		layer.cornerRadius = 14
		
		[periodLabel, rightStackView].forEach(addSubview)
		
		periodLabel.font = FontFamily.Nunito.semiBold.font(size: 17)
		priceLabel.font = FontFamily.Nunito.semiBold.font(size: 17)
		periodLabel.snp.makeConstraints { make in
			make.leading.equalToSuperview().offset(16)
			make.centerY.equalToSuperview()
		}
		
		rightStackView.snp.makeConstraints { make in
			make.trailing.equalToSuperview().offset(-16)
			make.centerY.equalToSuperview()
		}
		rightStackView.axis = .horizontal
		rightStackView.spacing = 10
		selectionIndicatorImageView.image = Asset.Images.disc.image
		priceLabel.font = FontFamily.Nunito.semiBold.font(size: 17)
		[priceLabel, selectionIndicatorImageView].forEach(rightStackView.addArrangedSubview)
	}
	
	func render(state: StarterIAPOptionView.State) {
		UIView.animate(withDuration: 0.2, delay: 0, options: .transitionCrossDissolve) {
			switch state {
			case .`default`:
				self.backgroundColor = UIColor(hexString: "9B9A9A").withAlphaComponent(0.1)
				self.periodLabel.textColor = Asset.Colors.white.color
				self.priceLabel.textColor = Asset.Colors.white.color
				self.selectionIndicatorImageView.isHidden = true
			case .selected:
				self.periodLabel.textColor = Asset.Colors.text.color
				self.priceLabel.textColor = Asset.Colors.text.color
				self.backgroundColor = Asset.Colors.white.color
				self.selectionIndicatorImageView.isHidden = false
			}
		}
	}
}

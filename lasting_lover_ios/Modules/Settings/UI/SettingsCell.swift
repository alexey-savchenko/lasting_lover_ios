//
//  SettingsCell.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 15.11.2021.
//

import Foundation
import UIKit

class SettingsCellViewModel {
	
	init(item: SettingsItem) {
		self.item = item
	}
	
	let item: SettingsItem
	
	var title: String {
		switch item {
		case .manageSubscription: return L10n.settingsManageSubscription
		case .notifications: return L10n.settingsNotifications
		case .privacyPolicy: return L10n.settingsPrivacyPolicy
		case .termsAndConditions: return L10n.settingsTermsAndConditions
		}
	}
}

class SettingsCell: UICollectionViewCell {
	
	let titleLabel = UILabel()
	let shevronImageView = UIImageView()
	let separatorView = UIView()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		setupUI()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setupUI() {
		[titleLabel, shevronImageView, separatorView].forEach(contentView.addSubview)
		titleLabel.font = FontFamily.Nunito.regular.font(size: 17)
		titleLabel.textColor = .white
		titleLabel.snp.makeConstraints { make in
			make.leading.equalToSuperview().offset(24)
			make.centerY.equalToSuperview()
		}
		shevronImageView.image = Asset.Images.chevronRight.image.tinted(Asset.Colors.button.color)
		shevronImageView.snp.makeConstraints { make in
			make.centerY.equalToSuperview()
			make.trailing.equalToSuperview().offset(-24)
		}
		
		separatorView.backgroundColor = .white.withAlphaComponent(0.3)
		separatorView.snp.makeConstraints { make in
			make.bottom.equalToSuperview()
			make.leading.equalToSuperview().offset(24)
			make.trailing.equalToSuperview()
			make.height.equalTo(1 / UIScreen.main.scale)
		}
	}
	
	func configure(with viewModel: SettingsCellViewModel) {
		titleLabel.text = viewModel.title
	}
}

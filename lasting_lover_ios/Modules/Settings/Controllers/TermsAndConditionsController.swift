//
//  TermsAndConditionsController.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 16.11.2021.
//

import Foundation
import UIKit
import RxSwift

class TermsAndConditionsController: SettingsScreen {
	
	let textView = UITextView()
	
	override func setupUI() {
		super.setupUI()
		
		titleLabel.text = L10n.settingsTermsAndConditions
		
		view.addSubview(textView)
		textView.backgroundColor = .clear
		textView.textColor = .white
		textView.font = FontFamily.Nunito.regular.font(size: 17)
		textView.showsVerticalScrollIndicator = false
		textView.snp.makeConstraints { make in
			make.leading.trailing.equalToSuperview().inset(24)
			make.top.equalTo(titleLabel.snp.bottom).offset(8)
			make.bottom.equalTo(view.safeAreaLayoutGuide)
		}
		
		textView.text = L10n.termsAndConditionsText
		
		navbarView.backButton.rx.tap.bind { [unowned self] in
			self.navigationController?.popViewController(animated: true)
		}
		.disposed(by: disposeBag)
	}
}

class PrivacyPolicyController: TermsAndConditionsController {
	override func setupUI() {
		super.setupUI()
		
		textView.text = L10n.privacyPolicyText
		titleLabel.text = L10n.settingsPrivacyPolicy
	}
}

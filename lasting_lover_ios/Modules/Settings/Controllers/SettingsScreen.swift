//
//  SettingsScreen.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 16.11.2021.
//

import UIKit

class SettingsScreen: ViewController<BackgroundImageView> {
	let navbarView = BackButtonNavbarView()
	let titleLabel = UILabel()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupUI()
	}
	
	func setupUI() {
		[navbarView, titleLabel].forEach(view.addSubview)
		
		navbarView.snp.makeConstraints { make in
			make.leading.trailing.equalToSuperview()
			make.top.equalTo(view.safeAreaLayoutGuide)
			make.height.equalTo(44)
		}
		
		titleLabel.snp.makeConstraints { make in
			make.leading.equalTo(24)
			make.top.equalTo(navbarView.snp.bottom).offset(8)
		}
	}
}

//
//  SettingsScreen.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 16.11.2021.
//

import UIKit
import RxSwift

class SettingsScreen: ViewController<BackgroundImageView> {
	
	let navbarView = BackButtonNavbarView()
	let titleLabel = UILabel()
	
	let disposeBag = DisposeBag()
	
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
		
		titleLabel.textColor = .white
		titleLabel.font = FontFamily.Nunito.semiBold.font(size: 22)
		titleLabel.snp.makeConstraints { make in
			make.leading.equalTo(24)
			make.top.equalTo(navbarView.snp.bottom).offset(8)
		}
	}
}

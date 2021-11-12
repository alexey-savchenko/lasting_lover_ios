//
//  AuthorViewController.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 12.11.2021.
//

import UIKit
import SnapKit
import RxSwift

class AuthorViewController: ViewController<BackgroundImageView> {
	
	let navbar = BackButtonNavbarView()
	let titleImageView = UIImageView()
	let titleLabel = UILabel()
	let subtitleLabel = UILabel()
	
	let viewModel: AuthorViewControllerViewModel
	private let disposeBag = DisposeBag()
	
	init(viewModel: AuthorViewControllerViewModel) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupUI()
		configure(with: viewModel)
	}
	
	fileprivate func setupNavbarView() {
		navbar.snp.makeConstraints { make in
			make.leading.trailing.equalToSuperview()
			make.top.equalTo(view.safeAreaLayoutGuide)
			make.height.equalTo(44)
		}
	}
	
	fileprivate func setupTitleImageView() {
		titleImageView.clipsToBounds = true
		titleImageView.layer.cornerRadius = 75.0
		titleImageView.snp.makeConstraints { make in
			make.centerX.equalToSuperview()
			make.top.equalTo(navbar.snp.bottom).offset(8)
			make.size.equalTo(150)
		}
	}
	
	fileprivate func setupTitleLabel() {
		titleLabel.textColor = Asset.Colors.white.color
		titleLabel.font = FontFamily.Nunito.bold.font(size: 36)
		titleLabel.snp.makeConstraints { make in
			make.leading.trailing.equalToSuperview().inset(24)
			make.top.equalTo(titleImageView.snp.bottom).offset(8)
		}
	}
	
	fileprivate func setupSubtitleLabel() {
		subtitleLabel.textColor = Asset.Colors.white.color.withAlphaComponent(0.8)
		subtitleLabel.font = FontFamily.Nunito.semiBold.font(size: 17)
		subtitleLabel.snp.makeConstraints { make in
			make.leading.trailing.equalToSuperview().inset(24)
			make.top.equalTo(titleLabel.snp.bottom).offset(8)
		}
	}
	
	fileprivate func setupUI() {
		[
			navbar,
			titleImageView,
			titleLabel,
			subtitleLabel
		]
			.forEach(view.addSubview)
		
		setupNavbarView()
		setupTitleImageView()
		setupTitleLabel()
		setupSubtitleLabel()
	}
	
	func configure(with viewModel: AuthorViewControllerViewModel) {
		viewModel.ouput.titleImage
			.map(Optional.init)
			.subscribe(titleImageView.rx.image)
			.disposed(by: disposeBag)
		titleLabel.text = viewModel.ouput.title
		subtitleLabel.text = viewModel.ouput.subtitle
	}
}

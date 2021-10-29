//
//  CategoryController.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 29.10.2021.
//

import UIKit

class CategoryController: ViewController<BackgroundImageView> {

	let viewModel: CategoryViewModel
	
	let navbarView = BackButtonNavbarView()
	
	init(viewModel: CategoryViewModel) {
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
	
	private func setupUI() {
		[navbarView].forEach(view.addSubview)
		navbarView.snp.makeConstraints { make in
			make.leading.trailing.equalToSuperview()
			make.top.equalTo(view.safeAreaLayoutGuide)
		}
	}
	
	private func configure(with viewModel: CategoryViewModel) {
		
	}
}

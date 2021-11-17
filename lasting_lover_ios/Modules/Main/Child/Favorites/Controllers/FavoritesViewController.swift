//
//  FavoritesViewController.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 07.11.2021.
//

import Foundation
import UIKit
import RxSwift
import RxDataSources

class FavoritesViewController: ViewController<BackgroundImageView> {

	let viewModel: FavoritesControllerViewModel
	private let disposeBag = DisposeBag()

	let navbar = NavbarViewBase()
	let titleLabel = UILabel()
	
	lazy var contentCollectionView: UICollectionView = {
		let layout = UICollectionViewFlowLayout()
		layout.scrollDirection = .vertical
		layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 68)
		layout.minimumLineSpacing = 16
		let cv = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
		cv.registerClass(StoryCell.self)
		return cv
	}()

	init(viewModel: FavoritesControllerViewModel) {
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

	fileprivate func setupNavbar() {
		navbar.setRightButtonImage(Asset.Images.setting.image.tinted(Asset.Colors.white.color))
		navbar.snp.makeConstraints { make in
			make.leading.trailing.equalToSuperview()
			make.top.equalTo(view.safeAreaLayoutGuide)
			make.height.equalTo(44)
		}
	}

	fileprivate func setupTitleLabel() {
		titleLabel.attributedText = NSAttributedString(
			string: L10n.mainTabFavorites,
			attributes: [
				.foregroundColor: UIColor.white,
				.font: FontFamily.Nunito.semiBold.font(size: 22)
			]
		)
		titleLabel.snp.makeConstraints { make in
			make.leading.equalToSuperview().offset(24)
			make.top.equalTo(navbar.snp.bottom).offset(8)
		}
	}
	
	func setupUI() {
		[navbar, titleLabel, contentCollectionView]
			.forEach(view.addSubview)

		setupNavbar()
		setupTitleLabel()
		contentCollectionView.backgroundColor = .clear
		contentCollectionView.snp.makeConstraints { make in
			make.leading.trailing.equalToSuperview()
			make.top.equalTo(titleLabel.snp.bottom).offset(8)
			make.bottom.equalTo(view.safeAreaLayoutGuide)
		}
	}
	
	func datasource() -> RxCollectionViewSectionedReloadDataSource<Section<StoryCellViewModel>> {
		return RxCollectionViewSectionedReloadDataSource<Section<StoryCellViewModel>> { ds, cv, indexPath, item in
			let cell: StoryCell = cv.dequeueReusableCell(forIndexPath: indexPath)
			cell.configure(with: item)
			return cell
		}
	}

	func configure(with viewModel: FavoritesControllerViewModel) {
		
		viewModel.output.contents
			.bind(to: contentCollectionView.rx.items(dataSource: datasource()))
			.disposed(by: disposeBag)
		
		contentCollectionView.rx.itemSelected
			.subscribe(viewModel.input.selectedStoryAtIndex)
			.disposed(by: disposeBag)
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		
		let cvBounds = contentCollectionView.bounds
		let itemHeight = 68.0
		let itemWidth = cvBounds.width - 48
		(contentCollectionView.collectionViewLayout as! UICollectionViewFlowLayout).itemSize = CGSize(width: itemWidth, height: itemHeight)
	}
}

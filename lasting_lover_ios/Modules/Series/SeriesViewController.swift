//
//  SeriesViewController.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 13.11.2021.
//

import UIKit
import RxSwift
import RxDataSources

class SeriesViewController: ViewController<BackgroundImageView> {
	
	let navbarView = BackButtonNavbarView()
	let imageView = UIImageView()
	let titleLabel = UILabel()
	let subtitleLabel = UILabel()
	
	let authorsCollectionView: UICollectionView = {
		let layout = UICollectionViewCenterLayout()
		layout.scrollDirection = .horizontal
		layout.estimatedItemSize = CGSize(width: 60, height: 90)
		let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
		cv.registerClass(CircleImageAndTitleCellCell.self)
		return cv
	}()
	
	let viewModel: SeriesControllerViewModel
	private let disposeBag = DisposeBag()
	
	init(viewModel: SeriesControllerViewModel) {
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
		navbarView.snp.makeConstraints { make in
			make.leading.trailing.equalToSuperview()
			make.top.equalTo(view.safeAreaLayoutGuide)
			make.height.equalTo(44)
		}
	}
	
	private func setupUI() {
		[navbarView,
		 imageView,
		 titleLabel,
		 subtitleLabel,
		 authorsCollectionView]
			.forEach(view.addSubview)
		
		setupNavbarView()
		imageView.contentMode = .scaleAspectFit
		imageView.snp.makeConstraints { make in
			make.centerX.equalToSuperview()
			make.top.equalTo(navbarView)
			make.size.equalTo(150)
		}
		titleLabel.textColor = .white
		titleLabel.font = FontFamily.Nunito.semiBold.font(size: 22)
		titleLabel.snp.makeConstraints { make in
			make.leading.trailing.equalToSuperview().inset(30)
			make.top.equalTo(imageView.snp.bottom).offset(8)
		}
		
		subtitleLabel.textColor = .white.withAlphaComponent(0.8)
		subtitleLabel.font = FontFamily.Nunito.regular.font(size: 17)
		subtitleLabel.numberOfLines = 0
		subtitleLabel.snp.makeConstraints { make in
			make.leading.trailing.equalToSuperview().inset(30)
			make.top.equalTo(titleLabel.snp.bottom).offset(8)
		}
		authorsCollectionView.backgroundColor = .clear
		authorsCollectionView.snp.makeConstraints { make in
			make.leading.trailing.equalToSuperview()
			make.top.equalTo(subtitleLabel.snp.bottom).offset(8)
			make.height.equalTo(110)
		}
	}
	
	private func configure(with viewModel: SeriesControllerViewModel) {
		viewModel.output.image
			.map(Optional.init)
			.subscribe(imageView.rx.image)
			.disposed(by: disposeBag)
		titleLabel.text = viewModel.output.title
		subtitleLabel.text = viewModel.output.subtitle
		viewModel.output.authors
			.bind(to: authorsCollectionView.rx.items(dataSource: authorsCollectionViewDataSource()))
			.disposed(by: disposeBag)
	}
	
	func authorsCollectionViewDataSource() -> RxCollectionViewSectionedReloadDataSource<Section<AuthorCellViewModel>> {
		return .init { ds, cv, indexPath, item in
			let cell: CircleImageAndTitleCellCell = cv.dequeueReusableCell(forIndexPath: indexPath)
			cell.configure(with: item)
			return cell
		}
	}
}

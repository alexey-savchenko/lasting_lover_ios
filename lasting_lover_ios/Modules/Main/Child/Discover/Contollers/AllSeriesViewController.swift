//
//  AllSeriesViewController.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 13.11.2021.
//

import UIKit
import RxUNILib
import RxDataSources
import RxSwift

class AllSeriesViewController: ViewController<BackgroundImageView> {
	
	let navbar = BackButtonNavbarView()
	let titleLabel = UILabel()
	lazy var collectionView: UICollectionView = {
		let layout = UICollectionViewFlowLayout()
		layout.minimumInteritemSpacing = 16
		layout.scrollDirection = .vertical
		let cv = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
		cv.registerClass(SeriesCell.self)
		return cv
	}()
	
	let viewModel: AllSeriesControllerViewModel
	
	let disposeBag = DisposeBag()
	
	init(viewModel: AllSeriesControllerViewModel) {
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
		navbar.snp.makeConstraints { make in
			make.leading.trailing.equalToSuperview()
			make.top.equalTo(view.safeAreaLayoutGuide)
			make.height.equalTo(44)
		}
	}
	
	fileprivate func setupTitleLabel() {
		titleLabel.attributedText = NSAttributedString(
			string: L10n.discoverAllSeries,
			attributes: [
				.foregroundColor: UIColor.white,
				.font: FontFamily.Nunito.bold.font(size: 36)
			]
		)
		titleLabel.snp.makeConstraints { make in
			make.leading.equalToSuperview().offset(24)
			make.top.equalTo(navbar.snp.bottom).offset(8)
		}
	}
	
	fileprivate func setupCollectionView() {
		collectionView.backgroundColor = .clear
		collectionView.snp.makeConstraints { make in
			make.leading.trailing.equalToSuperview()
			make.bottom.equalTo(view.safeAreaLayoutGuide)
			make.top.equalTo(titleLabel.snp.bottom).offset(8)
		}
	}
	
	private func setupUI() {
		[
			navbar,
			titleLabel,
			collectionView
		]
			.forEach(view.addSubview)
		
		setupNavbar()
		setupTitleLabel()
		setupCollectionView()
	}
	
	func configure(with viewModel: AllSeriesControllerViewModel) {
		viewModel.output.contents
			.bind(to: collectionView.rx.items(dataSource: datasource()))
			.disposed(by: disposeBag)
		collectionView.rx.itemSelected
			.subscribe(viewModel.input.selectedSeriesAtIndex)
			.disposed(by: disposeBag)
	}
	
	private func datasource() -> RxCollectionViewSectionedReloadDataSource<Section<AllSeriesCellViewModel>> {
		return .init { ds, cv, indexPath, item in
			let cell: SeriesCell = cv.dequeueReusableCell(forIndexPath: indexPath)
			cell.configure(with: item)
			return cell
		}
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		
		let width = collectionView.bounds.width - 28
		let height = 150.0
		(collectionView.collectionViewLayout as! UICollectionViewFlowLayout).itemSize = CGSize(width: width, height: height)
	}
}

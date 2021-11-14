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
	
	let contentScrollView = VerticalScrollingView()
	
	let authorsCollectionView: UICollectionView = {
		let layout = UICollectionViewCenterLayout()
		layout.scrollDirection = .horizontal
		layout.minimumLineSpacing = 24
		layout.minimumInteritemSpacing = 24
		layout.itemSize = CGSize(width: 60, height: 90)
		let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
		cv.registerClass(CircleImageAndTitleCellCell.self)
		return cv
	}()
	let authorsCollectionViewSeparatorView = UIView()
	
	let categoriesCollectionView: UICollectionView = {
		let layout = UICollectionViewCenterLayout()
		layout.scrollDirection = .horizontal
		layout.minimumLineSpacing = 24
		layout.minimumInteritemSpacing = 24
		layout.itemSize = CGSize(width: 60, height: 90)
		let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
		cv.registerClass(CircleImageAndTitleCellCell.self)
		return cv
	}()
	let categoriesCollectionViewSeparatorView = UIView()
	
	let listTitleLabel = UILabel()
	let listStackView = UIStackView()
	var cells: [StoryCell] = []
	
	
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
		[
			navbarView,
			imageView,
			titleLabel,
			subtitleLabel,
			contentScrollView
		]
			.forEach(view.addSubview)
		
		contentScrollView.snp.makeConstraints { make in
			make.leading.trailing.equalToSuperview()
			make.bottom.equalTo(view.safeAreaLayoutGuide)
			make.top.equalTo(subtitleLabel.snp.bottom).offset(8)
		}
		
		[
			authorsCollectionView,
			authorsCollectionViewSeparatorView,
			categoriesCollectionView,
			categoriesCollectionViewSeparatorView,
			listTitleLabel,
			listStackView
		]
			.forEach(contentScrollView.containerView.addSubview)
		
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
			make.top.equalToSuperview().offset(8)
			make.height.equalTo(110)
		}
		authorsCollectionViewSeparatorView.backgroundColor = UIColor.white.withAlphaComponent(0.5)
		authorsCollectionViewSeparatorView.snp.makeConstraints { make in
			make.leading.trailing.equalToSuperview().inset(8)
			make.height.equalTo(1 / UIScreen.main.scale)
			make.top.equalTo(authorsCollectionView.snp.bottom).offset(8)
		}
		
		categoriesCollectionView.backgroundColor = .clear
		categoriesCollectionView.snp.makeConstraints { make in
			make.leading.trailing.equalToSuperview()
			make.top.equalTo(authorsCollectionViewSeparatorView.snp.bottom).offset(8)
			make.height.equalTo(110)
		}
		categoriesCollectionViewSeparatorView.backgroundColor = UIColor.white.withAlphaComponent(0.5)
		categoriesCollectionViewSeparatorView.snp.makeConstraints { make in
			make.leading.trailing.equalToSuperview().inset(8)
			make.height.equalTo(1 / UIScreen.main.scale)
			make.top.equalTo(categoriesCollectionView.snp.bottom).offset(8)
		}
		
		listTitleLabel.attributedText = NSAttributedString(
			string: L10n.seriesList,
			attributes: [
				.foregroundColor: UIColor.white,
				.font: FontFamily.Nunito.semiBold.font(size: 22)
			]
		)
		listTitleLabel.snp.makeConstraints { make in
			make.leading.equalToSuperview().offset(24)
			make.top.equalTo(categoriesCollectionViewSeparatorView.snp.bottom).offset(8)
		}
		
		listStackView.axis = .vertical
		listStackView.spacing = 16
		listStackView.snp.makeConstraints { make in
			make.leading.trailing.equalToSuperview().inset(24)
			make.top.equalTo(listTitleLabel.snp.bottom).offset(16)
			make.bottom.equalToSuperview().offset(-8)
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
		viewModel.output.categories
			.bind(to: categoriesCollectionView.rx.items(dataSource: categoriesCollectionViewDataSource()))
			.disposed(by: disposeBag)
		
		let content = viewModel.output.stories.share()
		
		content
			.compactMap { $0.item }
			.map { viewModels -> [StoryCell] in
				let cells = viewModels.map { vm -> StoryCell in
					let cell = StoryCell()
					cell.configure(with: vm)
					return cell
				}
				return cells
			}
			.subscribe(onNext: { [weak self] cells in
				self?.cells = cells
				cells.forEach { cell in
					self?.listStackView.addArrangedSubview(cell)
					cell.snp.makeConstraints { make in
						make.leading.trailing.equalToSuperview()
						make.height.equalTo(68)
					}
				}
			})
			.disposed(by: disposeBag)
	}
	
	func categoriesCollectionViewDataSource() -> RxCollectionViewSectionedReloadDataSource<Section<SleepCategoryCellViewModel>> {
		return .init { ds, cv, indexPath, item in
			let cell: CircleImageAndTitleCellCell = cv.dequeueReusableCell(forIndexPath: indexPath)
			cell.configure(with: item)
			return cell
		}
	}
	
	func authorsCollectionViewDataSource() -> RxCollectionViewSectionedReloadDataSource<Section<AuthorCellViewModel>> {
		return .init { ds, cv, indexPath, item in
			let cell: CircleImageAndTitleCellCell = cv.dequeueReusableCell(forIndexPath: indexPath)
			cell.configure(with: item)
			return cell
		}
	}
}

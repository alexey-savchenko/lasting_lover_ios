//
//  CategoryViewController.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 14.11.2021.
//

import UIKit
import RxSwift
import RxDataSources
import UNILibCore

class CategoryViewController: ViewController<BackgroundImageView> {
		
	let navbarView = BackButtonNavbarView()
	let titleImageView = UIImageView()
	let titleLabel = UILabel()
	let subtitleLabel = UILabel()
	
	lazy var contentCollectionView: UICollectionView = {
		let layout = UICollectionViewFlowLayout()
		layout.scrollDirection = .vertical
		layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 68)
		layout.minimumLineSpacing = 16
		let cv = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
		cv.registerClass(StoryCell.self)
		return cv
	}()
	
	let activityIndicatorView = UIActivityIndicatorView(style: .large)
	
	let viewModel: CategoryControllerViewModel
	private let disposeBag = DisposeBag()
	
	init(viewModel: CategoryControllerViewModel) {
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
		[
			navbarView,
			titleImageView,
			titleLabel,
			subtitleLabel,
			contentCollectionView,
			activityIndicatorView
		]
			.forEach(view.addSubview)
		
		navbarView.snp.makeConstraints { make in
			make.leading.trailing.equalToSuperview()
			make.top.equalTo(view.safeAreaLayoutGuide)
			make.height.equalTo(44)
		}
		
		titleImageView.contentMode = .scaleAspectFit
		titleImageView.snp.makeConstraints { make in
			make.top.equalTo(navbarView)
			make.leading.trailing.equalToSuperview()
			make.height.equalTo(200)
		}
		
		titleLabel.textColor = .white
		titleLabel.font = FontFamily.Nunito.semiBold.font(size: 22)
		titleLabel.snp.makeConstraints { make in
			make.leading.trailing.equalToSuperview().inset(30)
			make.top.equalTo(titleImageView.snp.bottom).offset(8)
		}
		
		subtitleLabel.textColor = .white.withAlphaComponent(0.8)
		subtitleLabel.font = FontFamily.Nunito.regular.font(size: 17)
		subtitleLabel.numberOfLines = 0
		subtitleLabel.snp.makeConstraints { make in
			make.leading.trailing.equalToSuperview().inset(30)
			make.top.equalTo(titleLabel.snp.bottom).offset(8)
		}
		
		contentCollectionView.backgroundColor = .clear
		contentCollectionView.snp.makeConstraints { make in
			make.leading.trailing.equalToSuperview()
			make.bottom.equalTo(view.safeAreaLayoutGuide)
			make.top.equalTo(subtitleLabel.snp.bottom).offset(8)
		}
		
		activityIndicatorView.snp.makeConstraints { make in
			make.center.equalTo(contentCollectionView)
		}
	}
	
	private func configure(with viewModel: CategoryControllerViewModel) {
		
		viewModel.output.image
			.map(Optional.init)
			.subscribe(titleImageView.rx.image)
			.disposed(by: disposeBag)
		
		titleLabel.text = viewModel.output.title
		subtitleLabel.text = viewModel.output.subtitle
		
		contentCollectionView.rx.itemSelected
			.subscribe(viewModel.input.selectedStoryAtIndex)
			.disposed(by: disposeBag)
		
		let contents = viewModel.output.stories.share()
		
		contents
			.compactMap { $0.item }
			.bind(to: contentCollectionView.rx.items(dataSource: datasource()))
			.disposed(by: disposeBag)
		
		navbarView.backButton.rx.tap
			.subscribe(viewModel.input.backTap)
			.disposed(by: disposeBag)
		
		contents
			.compactMap { value -> HashableWrapper<AppError>? in
				if case .error(let wrapped) = value {
					return wrapped
				} else {
					return nil
				}
			}
			.distinctUntilChanged()
			.bind { value in
				self.presentError(value.value)
			}
			.disposed(by: disposeBag)
		
		contents
			.map { value -> Bool in
				if case .loading = value {
					return true
				} else {
					return false
				}
			}
				.bind { [weak self] value in
					self?.activityIndicatorView.isHidden = !value
					if value {
						self?.activityIndicatorView.startAnimating()
					} else {
						self?.activityIndicatorView.stopAnimating()
					}
				}
				.disposed(by: disposeBag)
	}
	
	func datasource() -> RxCollectionViewSectionedReloadDataSource<Section<StoryCellViewModel>> {
		return RxCollectionViewSectionedReloadDataSource<Section<StoryCellViewModel>> { ds, cv, indexPath, item in
			let cell: StoryCell = cv.dequeueReusableCell(forIndexPath: indexPath)
			cell.configure(with: item)
			return cell
		}
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		
		let cvBounds = contentCollectionView.bounds
		let itemHeight = 68.0
		let itemWidth = cvBounds.width - 48
		(contentCollectionView.collectionViewLayout as! UICollectionViewFlowLayout).itemSize = CGSize(width: itemWidth, height: itemHeight)
	}
}

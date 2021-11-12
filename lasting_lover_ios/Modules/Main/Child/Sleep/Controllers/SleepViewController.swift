//
//  SleepViewController.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 03.10.2021.
//

import UIKit
import RxDataSources
import RxUNILib
import UNILibCore
import RxSwift

class SleepViewController: ViewController<BackgroundImageView> {
	let viewModel: SleepControllerViewModel
	
	let navbar = NavbarViewBase()
	
	let titleLabel = UILabel()
	
	let contentScrollView = VerticalScrollingView()
	let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
	
	let contentStackView = UIStackView()
	
	lazy var categoriesCollectionView: UICollectionView = {
		let layout = UICollectionViewFlowLayout()
		layout.scrollDirection = .horizontal
		layout.itemSize = CGSize(width: 72, height: 100)
		layout.minimumLineSpacing = 16
		layout.minimumInteritemSpacing = 16
		layout.sectionInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
		let c = UICollectionView(frame: .zero, collectionViewLayout: layout)
		c.showsHorizontalScrollIndicator = false
		c.registerClass(CircleImageAndTitleCellCell.self)
		return c
	}()
	
	let featuredStoriesContainerView = UIView()
	let featuredStoriesTitleLabel = UILabel()
	let featuredStoriesSeeAllButton = UIButton()
	lazy var featuredStoriesCollectionView: UICollectionView = {
		let layout = SeriesLayout()
		let c = UICollectionView(frame: .zero, collectionViewLayout: layout)
		c.showsHorizontalScrollIndicator = false
		c.registerClass(CardCell.self)
		return c
	}()
	
	private let disposebag = DisposeBag()
	
	init(viewModel: SleepControllerViewModel) {
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
		navbar.setTitle(
			NSAttributedString(
				string: "Lasting lover",
				attributes: [
					.foregroundColor: Asset.Colors.white.color,
					.font: FontFamily.Nunito.semiBold.font(size: 22)
				]
			)
		)
		navbar.setRightButtonImage(Asset.Images.setting.image.tinted(Asset.Colors.white.color))
		navbar.snp.makeConstraints { make in
			make.leading.trailing.equalToSuperview()
			make.top.equalTo(view.safeAreaLayoutGuide)
			make.height.equalTo(44)
		}
	}
	
	fileprivate func setupTitleLabel() {
		titleLabel.attributedText = NSAttributedString(
			string: L10n.sleepTitle,
			attributes: [
				.foregroundColor: Asset.Colors.white.color,
				.font: FontFamily.Nunito.bold.font(size: 36)
			]
		)
		titleLabel.numberOfLines = 0
		titleLabel.snp.makeConstraints { make in
			make.leading.equalToSuperview().offset(24)
			make.top.equalTo(navbar.snp.bottom)
			make.trailing.equalToSuperview().offset(-32)
			make.height.equalTo(42)
		}
	}
	
	fileprivate func setupCategoriesBlock() {
		categoriesCollectionView.backgroundColor = .clear
		categoriesCollectionView.snp.makeConstraints { make in
			make.leading.trailing.equalToSuperview()
			make.height.equalTo(100)
		}
	}
	
	fileprivate func setupFeaturedBlock() {
		featuredStoriesContainerView.snp.makeConstraints { make in
			make.leading.trailing.equalToSuperview()
		}
		
		[
			featuredStoriesTitleLabel,
			featuredStoriesCollectionView,
			featuredStoriesSeeAllButton
		]
			.forEach(featuredStoriesContainerView.addSubview)
		
		featuredStoriesTitleLabel.attributedText = NSAttributedString(
			string: L10n.sleepFeatured,
			attributes: [
				.foregroundColor: Asset.Colors.white.color,
				.font: FontFamily.Nunito.semiBold.font(size: 22)
			]
		)
		featuredStoriesTitleLabel.snp.makeConstraints { make in
			make.leading.equalToSuperview().offset(24)
			make.top.equalToSuperview()
		}
		featuredStoriesSeeAllButton.setAttributedTitle(
			NSAttributedString(
				string: L10n.discoverSeeAll,
				attributes: [
					.foregroundColor: Asset.Colors.white.color,
					.font: FontFamily.Nunito.semiBold.font(size: 16)
				]
			),
			for: .normal
		)
		featuredStoriesSeeAllButton.snp.makeConstraints { make in
			make.centerY.equalTo(featuredStoriesTitleLabel)
			make.trailing.equalToSuperview().offset(-24)
		}
		
		featuredStoriesCollectionView.backgroundColor = .clear
		featuredStoriesCollectionView.snp.makeConstraints { make in
			make.leading.trailing.equalToSuperview()
			make.height.equalTo(270)
			make.top.equalTo(featuredStoriesTitleLabel.snp.bottom).offset(8)
			make.bottom.equalToSuperview()
		}
	}
	
	fileprivate func setupContentScrollView() {
		contentScrollView.snp.makeConstraints { make in
			make.leading.trailing.equalToSuperview()
			make.top.equalTo(titleLabel.snp.bottom).offset(8)
			make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-8)
		}
		contentScrollView.containerView.addSubview(contentStackView)
		contentStackView.axis = .vertical
		contentStackView.spacing = 8
		contentStackView.snp.makeConstraints { make in
			make.edges.equalToSuperview()
		}
		
		[categoriesCollectionView, featuredStoriesContainerView]
			.forEach(contentStackView.addArrangedSubview)
		
		contentStackView.setCustomSpacing(24, after: categoriesCollectionView)
		
		setupCategoriesBlock()
		setupFeaturedBlock()
	}
	
	fileprivate func setupActivityIndicator() {
		activityIndicator.snp.makeConstraints { make in
			make.center.equalTo(contentScrollView)
		}
	}
	
	func setupUI() {
		[navbar, titleLabel, contentScrollView, activityIndicator]
			.forEach(view.addSubview)
		
		setupNavbar()
		setupTitleLabel()
		
		setupContentScrollView()
		setupActivityIndicator()
	}
	
	func configure(with viewModel: SleepControllerViewModel) {
		let data = viewModel.output.data.share(replay: 1, scope: .whileConnected)
		
		let isLoading = data.map { value -> Bool in
			if case .loading = value {
				return true
			} else {
				return false
			}
		}
			.bind { value in
				self.activityIndicator.isHidden = !value
				self.contentScrollView.isHidden = value
				if value {
					self.activityIndicator.startAnimating()
				} else {
					self.activityIndicator.stopAnimating()
				}
			}
			.disposed(by: disposebag)
		
		let content = data
			.compactMap { value -> SleepData? in
				if case .item(let item) = value {
					return item
				} else {
					return nil
				}
			}
			.distinctUntilChanged()
		
		content
			.map { $0.categories }
			.map { array in return array.map(SleepCategoryCellViewModel.init) }
			.map(Section.init)
			.map(toArray)
			.bind(to: categoriesCollectionView.rx.items(dataSource: categoriesCollectionViewDataSource()))
			.disposed(by: disposebag)
		
		content
			.map { $0.featuredStories }
			.map { array in return array.map(SleepFeaturedStoryCellViewModel.init) }
			.map(Section.init)
			.map(toArray)
			.bind(to: featuredStoriesCollectionView.rx.items(dataSource: featuredStoriesCollectionViewDataSource()))
			.disposed(by: disposebag)
		
		categoriesCollectionView.rx.itemSelected
			.subscribe(viewModel.input.selectedCategoryAtIndex)
			.disposed(by: disposebag)
		featuredStoriesCollectionView.rx.itemSelected
			.subscribe(viewModel.input.selectedFeaturedStoryAtIndex)
			.disposed(by: disposebag)
	}
	
	private func featuredStoriesCollectionViewDataSource() -> RxCollectionViewSectionedReloadDataSource<Section<SleepFeaturedStoryCellViewModel>> {
		return RxCollectionViewSectionedReloadDataSource { ds, cv, indexPath, item in
			let cell: CardCell = cv.dequeueReusableCell(forIndexPath: indexPath)
			cell.configure(with: item)
			return cell
		}
	}
	
	private func categoriesCollectionViewDataSource() -> RxCollectionViewSectionedReloadDataSource<Section<SleepCategoryCellViewModel>> {
		return RxCollectionViewSectionedReloadDataSource { ds, cv, indexPath, item in
			let cell: CircleImageAndTitleCellCell = cv.dequeueReusableCell(forIndexPath: indexPath)
			cell.configure(with: item)
			return cell
		}
	}
}

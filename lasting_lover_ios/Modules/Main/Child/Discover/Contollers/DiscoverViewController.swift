//
//  DiscoverViewController.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 03.10.2021.
//

import UIKit
import RxSwift
import UNILibCore
import RxDataSources

class DiscoverViewController: ViewController<BackgroundImageView> {
	let viewModel: DiscoverControllerViewModel
	
	let topArtworkImageView = UIImageView(image: Asset.Images.lips.image)
	let navbar = NavbarViewBase()
	let titleLabel = UILabel()
	
	let contentScrollView = VerticalScrollingView()
	let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
	
	let contentStackView = UIStackView()
	
	let authorsContainerView = UIView()
	let authorsTitleLabel = UILabel()
	lazy var authorsCollectionView: UICollectionView = {
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
	
	let seriesContainerView = UIView()
	let seriesTitleLabel = UILabel()
	let seeAllSeriesButton = UIButton()
	lazy var seriesCollectionView: UICollectionView = {
		let layout = SeriesLayout()
		let c = UICollectionView(frame: .zero, collectionViewLayout: layout)
		c.showsHorizontalScrollIndicator = false
		c.registerClass(CardCell.self)
		return c
	}()
	
	let categoriesContainerView = UIView()
	let categoriesTitleLabel = UILabel()
	lazy var categoriesCollectionView: UICollectionView = {
		let layout = UICollectionViewFlowLayout()
		layout.scrollDirection = .horizontal
		layout.minimumLineSpacing = 8
		layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
		layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
		let c = UICollectionView(frame: .zero, collectionViewLayout: layout)
		c.showsHorizontalScrollIndicator = false
		c.registerClass(CategoryCell.self)
		return c
	}()
	
	let featuredStoriesContainerView = UIView()
	let featuredStoriesTitleLabel = UILabel()
	let allFeaturedStoriesButton = UIButton()
	lazy var featuredStoriesCollectionView: UICollectionView = {
		let layout = StoriesLayout()
		let c = UICollectionView(frame: .zero, collectionViewLayout: layout)
		c.showsHorizontalScrollIndicator = false
		c.registerClass(CardCell.self)
		return c
	}()
	
	private let disposebag = DisposeBag()
	
	init(viewModel: DiscoverControllerViewModel) {
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
	
	fileprivate func setupTopArtwork() {
		topArtworkImageView.contentMode = .scaleAspectFit
		topArtworkImageView.snp.makeConstraints { make in
			make.top.equalToSuperview()
			make.trailing.equalToSuperview().offset(40)
		}
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
			string: L10n.discoverTitle,
			attributes: [
				.foregroundColor: Asset.Colors.white.color,
				.font: FontFamily.Nunito.bold.font(size: 36)
			]
		)
		titleLabel.numberOfLines = 0
		titleLabel.snp.makeConstraints { make in
			make.leading.equalToSuperview().offset(24)
			make.top.equalTo(navbar)
			make.trailing.equalToSuperview().offset(-32)
		}
	}
	
	fileprivate func setupAuthorsBlock() {
		
		[authorsTitleLabel, authorsCollectionView].forEach(authorsContainerView.addSubview)
		
		authorsTitleLabel.attributedText = NSAttributedString(
			string: L10n.discoverAuthors,
			attributes: [
				.foregroundColor: Asset.Colors.white.color,
				.font: FontFamily.Nunito.semiBold.font(size: 22)
			]
		)
		authorsTitleLabel.snp.makeConstraints { make in
			make.leading.equalToSuperview().offset(24)
			make.top.equalToSuperview()
		}
		authorsCollectionView.backgroundColor = .clear
		authorsCollectionView.snp.makeConstraints { make in
			make.leading.trailing.equalToSuperview()
			make.height.equalTo(110)
			make.top.equalTo(authorsTitleLabel.snp.bottom).offset(8)
			make.bottom.equalToSuperview()
		}
	}
	
	fileprivate func setupCategoriesBlock() {
		
		[categoriesTitleLabel, categoriesCollectionView].forEach(categoriesContainerView.addSubview)
		
		categoriesTitleLabel.snp.makeConstraints { make in
			make.leading.equalToSuperview().offset(24)
			make.top.equalToSuperview()
		}
		categoriesTitleLabel.attributedText = NSAttributedString(
			string: L10n.discoverCategories,
			attributes: [
				.foregroundColor: Asset.Colors.white.color,
				.font: FontFamily.Nunito.semiBold.font(size: 22)
			]
		)
//		categoriesCollectionView.isScrollEnabled = false
		categoriesCollectionView.backgroundColor = .clear
		categoriesCollectionView.snp.makeConstraints { make in
			make.leading.trailing.equalToSuperview()
			make.height.equalTo(55)
			make.top.equalTo(categoriesTitleLabel.snp.bottom).offset(16)
			make.bottom.equalToSuperview()
		}
	}
	
	fileprivate func setupFeaturedStoriesBlock() {
		[featuredStoriesTitleLabel, featuredStoriesCollectionView, allFeaturedStoriesButton]
			.forEach(featuredStoriesContainerView.addSubview)
		
		featuredStoriesTitleLabel.attributedText = NSAttributedString(
			string: L10n.discoverNewSexyStories,
			attributes: [
				.foregroundColor: Asset.Colors.white.color,
				.font: FontFamily.Nunito.semiBold.font(size: 22)
			]
		)
		featuredStoriesTitleLabel.snp.makeConstraints { make in
			make.leading.equalToSuperview().offset(24)
			make.top.equalToSuperview()
		}
		allFeaturedStoriesButton.setAttributedTitle(
			NSAttributedString(
				string: L10n.discoverSeeAll,
				attributes: [
					.foregroundColor: Asset.Colors.white.color,
					.font: FontFamily.Nunito.semiBold.font(size: 16)
				]
			),
			for: .normal
		)
		allFeaturedStoriesButton.snp.makeConstraints { make in
			make.centerY.equalTo(featuredStoriesTitleLabel)
			make.trailing.equalToSuperview().offset(-24)
		}
		featuredStoriesCollectionView.backgroundColor = .clear
		featuredStoriesCollectionView.snp.makeConstraints { make in
			make.top.equalTo(featuredStoriesTitleLabel.snp.bottom).offset(16)
			make.leading.trailing.equalToSuperview()
			make.height.equalTo(244)
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
		
		[
			authorsContainerView,
			seriesContainerView,
			categoriesContainerView,
			featuredStoriesContainerView
		]
			.forEach(contentStackView.addArrangedSubview)
		
		setupAuthorsBlock()
		setupSeriesBlock()
		setupCategoriesBlock()
		setupFeaturedStoriesBlock()
	}
	
	fileprivate func setupSeriesBlock() {
		
		[seriesTitleLabel, seriesCollectionView, seeAllSeriesButton]
			.forEach(seriesContainerView.addSubview)
		
		seriesTitleLabel.attributedText = NSAttributedString(
			string: L10n.discoverFeaturedSeries,
			attributes: [
				.foregroundColor: Asset.Colors.white.color,
				.font: FontFamily.Nunito.semiBold.font(size: 22)
			]
		)
		seriesTitleLabel.snp.makeConstraints { make in
			make.leading.equalToSuperview().offset(24)
			make.top.equalToSuperview()
		}
		seriesCollectionView.isScrollEnabled = false
		seriesCollectionView.backgroundColor = .clear
		seriesCollectionView.snp.makeConstraints { make in
			make.leading.trailing.equalToSuperview()
			make.height.equalTo(270)
			make.top.equalTo(seriesTitleLabel.snp.bottom).offset(8)
			make.bottom.equalToSuperview()
		}
		seeAllSeriesButton.snp.makeConstraints { make in
			make.trailing.equalToSuperview().offset(-24)
			make.centerY.equalTo(seriesTitleLabel)
		}
		seeAllSeriesButton.setAttributedTitle(
			NSAttributedString(
				string: L10n.discoverSeeAll,
				attributes: [
					.foregroundColor: Asset.Colors.white.color,
					.font: FontFamily.Nunito.semiBold.font(size: 16)
				]
			),
			for: .normal
		)
	}
	
	fileprivate func setupActivityIndicator() {
		activityIndicator.snp.makeConstraints { make in
			make.center.equalTo(contentScrollView)
		}
	}
	
	func setupUI() {
		[topArtworkImageView,
		 navbar,
		 titleLabel,
		 contentScrollView,
		 activityIndicator]
			.forEach(view.addSubview)
		
		setupTopArtwork()
		setupNavbar()
		setupTitleLabel()
		setupContentScrollView()
		setupActivityIndicator()
	}
	
	func configure(with viewModel: DiscoverControllerViewModel) {
		
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
			.compactMap { value -> DiscoverData? in
				if case .item(let item) = value {
					return item
				} else {
					return nil
				}
			}
			.distinctUntilChanged()
		
		content
			.map { $0.authors }
			.map { array in return array.map(AuthorCellViewModel.init) }
			.map(Section.init)
			.map(toArray)
			.bind(to: authorsCollectionView.rx.items(dataSource: authorsCollectionViewDataSource()))
			.disposed(by: disposebag)
		
		content
			.map { $0.series }
			.map { array in
				return array
					.filter { $0.featured == 1 }
					.prefix(2)
					.map(SeriesCellViewModel.init)
			}
			.map(Section.init)
			.map(toArray)
			.bind(to: seriesCollectionView.rx.items(dataSource: seriesCollectionViewDataSource()))
			.disposed(by: disposebag)
		
		content
			.map { $0.categories }
			.map { array in return array.map(CategoryCellViewModel.init) }
			.map(Section.init)
			.map(toArray)
			.bind(to: categoriesCollectionView.rx.items(dataSource: categoriesCollectionViewDataSource()))
			.disposed(by: disposebag)
		
		content
			.map { $0.featuredStories }
			.map { array in
				return array
					.enumerated()
					.map { idx, value -> DiscoverStoryCellViewModel in
						if idx == 0 {
							return DiscoverStoryCellViewModel(story: value, showNewTopicAccessory: true)
						} else {
							return DiscoverStoryCellViewModel(story: value, showNewTopicAccessory: false)
						}
					}
			}
			.map(Section.init)
			.map(toArray)
			.bind(to: featuredStoriesCollectionView.rx.items(dataSource: storiesCollectionViewDataSource()))
			.disposed(by: disposebag)
		
		data
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
			.disposed(by: disposebag)
		
		authorsCollectionView.rx.itemSelected
			.subscribe(viewModel.input.selectedAuthorAtIndex)
			.disposed(by: disposebag)
		
		seeAllSeriesButton.rx.tap
			.subscribe(viewModel.input.allSeriesButtonTap)
			.disposed(by: disposebag)
		
		seriesCollectionView.rx.itemSelected
			.subscribe(viewModel.input.featuredSeriesSelectedAtIndex)
			.disposed(by: disposebag)
	}
	
	private func storiesCollectionViewDataSource() -> RxCollectionViewSectionedReloadDataSource<Section<DiscoverStoryCellViewModel>> {
		return RxCollectionViewSectionedReloadDataSource { ds, cv, indexPath, item in
			let cell: CardCell = cv.dequeueReusableCell(forIndexPath: indexPath)
			cell.configure(with: item)
			return cell
		}
	}
	
	private func seriesCollectionViewDataSource() -> RxCollectionViewSectionedReloadDataSource<Section<SeriesCellViewModel>> {
		return RxCollectionViewSectionedReloadDataSource { ds, cv, indexPath, item in
			let cell: CardCell = cv.dequeueReusableCell(forIndexPath: indexPath)
			cell.configure(with: item)
			return cell
		}
	}
	
	private func authorsCollectionViewDataSource() -> RxCollectionViewSectionedReloadDataSource<Section<AuthorCellViewModel>> {
		return RxCollectionViewSectionedReloadDataSource { ds, cv, indexPath, item in
			let cell: CircleImageAndTitleCellCell = cv.dequeueReusableCell(forIndexPath: indexPath)
			cell.configure(with: item)
			return cell
		}
	}
	
	private func categoriesCollectionViewDataSource() -> RxCollectionViewSectionedReloadDataSource<Section<CategoryCellViewModel>> {
		return RxCollectionViewSectionedReloadDataSource { ds, cv, indexPath, item in
			let cell: CategoryCell = cv.dequeueReusableCell(forIndexPath: indexPath)
			cell.configure(with: item)
			return cell
		}
	}
}

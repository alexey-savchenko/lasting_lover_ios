//
//  AuthorViewController.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 12.11.2021.
//

import UIKit
import SnapKit
import RxSwift
import RxDataSources

class AuthorViewController: ViewController<BackgroundImageView> {
	
	let navbar = BackButtonNavbarView()
	let titleImageView = UIImageView()
	let titleLabel = UILabel()
	let subtitleLabel = UILabel()
	
	let authorTopStoriesLabel = UILabel()
	let authorAllStoriesButton = UIButton()
	private lazy var authorTopStoriesCollectionView: UICollectionView = {
		let layout = SeriesLayout()
		let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
		cv.showsHorizontalScrollIndicator = false
		cv.registerClass(CardCell.self)
		return cv
	}()
	
	let activityIndicationView = UIActivityIndicatorView(style: .large)
	
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
		subtitleLabel.numberOfLines = 0
		subtitleLabel.snp.makeConstraints { make in
			make.leading.trailing.equalToSuperview().inset(24)
			make.top.equalTo(titleLabel.snp.bottom).offset(8)
		}
	}
	
	fileprivate func setupTopStoriesTitleLabel() {
		authorTopStoriesLabel.attributedText = NSAttributedString(
			string: L10n.authorTopStoriesTitle,
			attributes: [
				.foregroundColor: Asset.Colors.white.color,
				.font: FontFamily.Nunito.semiBold.font(size: 22)
			]
		)
		authorTopStoriesLabel.snp.makeConstraints { make in
			make.leading.equalToSuperview().offset(24)
			make.top.equalTo(subtitleLabel.snp.bottom).offset(40)
		}
	}
	
	fileprivate func setupAllStoriesButton() {
		authorAllStoriesButton.setAttributedTitle(
			NSAttributedString(
				string: L10n.discoverSeeAll,
				attributes: [
					.foregroundColor: Asset.Colors.white.color,
					.font: FontFamily.Nunito.semiBold.font(size: 16)
				]
			),
			for: .normal
		)
		authorAllStoriesButton.snp.makeConstraints { make in
			make.centerY.equalTo(authorTopStoriesLabel)
			make.trailing.equalToSuperview().offset(-24)
		}
	}
	
	fileprivate func setupCollectionView() {
		authorTopStoriesCollectionView.backgroundColor = .clear
		authorTopStoriesCollectionView.snp.makeConstraints { make in
			make.leading.trailing.equalToSuperview()
			make.top.equalTo(authorTopStoriesLabel.snp.bottom).offset(16)
			make.bottom.equalTo(view.safeAreaLayoutGuide)
		}
	}
	
	fileprivate func setupActivityIndicatorView() {
		activityIndicationView.snp.makeConstraints { make in
			make.center.equalTo(authorTopStoriesCollectionView)
		}
	}
	
	fileprivate func setupUI() {
		[
			navbar,
			titleImageView,
			titleLabel,
			subtitleLabel,
			authorTopStoriesLabel,
			authorAllStoriesButton,
			authorTopStoriesCollectionView,
			activityIndicationView
		]
			.forEach(view.addSubview)
		
		setupNavbarView()
		setupTitleImageView()
		setupTitleLabel()
		setupSubtitleLabel()
		setupTopStoriesTitleLabel()
		setupAllStoriesButton()
		setupCollectionView()
		setupActivityIndicatorView()
	}
	
	func configure(with viewModel: AuthorViewControllerViewModel) {
		viewModel.ouput.titleImage
			.map(Optional.init)
			.subscribe(titleImageView.rx.image)
			.disposed(by: disposeBag)
		titleLabel.text = viewModel.ouput.title
		subtitleLabel.text = viewModel.ouput.subtitle
		
		let data = viewModel.ouput.content.share()
		
		data
			.subscribe(onNext: { [weak self] value in
				if case .error(let wrapped) = value {
					self?.presentError(wrapped.value)
				}
			})
			.disposed(by: disposeBag)
		
		data
			.subscribe(onNext: { [weak self] value in
				if case .loading = value {
					self?.activityIndicationView.isHidden = false
					self?.activityIndicationView.startAnimating()
				} else {
					self?.activityIndicationView.isHidden = true
					self?.activityIndicationView.stopAnimating()
				}
			})
			.disposed(by: disposeBag)
		
		data
			.compactMap { value in
				if case .item(let item) = value {
					return item
				} else {
					return nil
				}
			}
			.bind(to: authorTopStoriesCollectionView.rx.items(dataSource: datasource()))
			.disposed(by: disposeBag)
	}
	
	func datasource() -> RxCollectionViewSectionedReloadDataSource<Section<AuthorStoryCellViewModel>> {
		return .init { ds, cv, indexPath, item in
			let cell: CardCell = cv.dequeueReusableCell(forIndexPath: indexPath)
			cell.configure(with: item)
			return cell
		}
	}
}

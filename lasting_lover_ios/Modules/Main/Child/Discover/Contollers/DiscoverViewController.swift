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
	
	let authorsTitleLabel = UILabel()
	lazy var authorsCollectionView: UICollectionView = {
		let layout = UICollectionViewFlowLayout()
		layout.scrollDirection = .horizontal
		layout.itemSize = CGSize(width: 72, height: 128)
		layout.minimumLineSpacing = 16
		layout.minimumInteritemSpacing = 16
		layout.sectionInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
		let c = UICollectionView(frame: .zero, collectionViewLayout: layout)
		c.registerClass(CircleImageAndTitleCellCell.self)
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
			make.leading.equalToSuperview().offset(16)
			make.top.equalTo(navbar)
			make.trailing.equalToSuperview().offset(-32)
		}
	}
	
	fileprivate func setupContentScrollView() {
		contentScrollView.snp.makeConstraints { make in
			make.leading.trailing.equalToSuperview()
			make.top.equalTo(titleLabel.snp.bottom).offset(8)
			make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-8)
		}
		[authorsTitleLabel, authorsCollectionView].forEach(contentScrollView.containerView.addSubview)
		authorsTitleLabel.attributedText = NSAttributedString(
			string: L10n.discoverAuthors,
			attributes: [
				.foregroundColor: Asset.Colors.white.color,
				.font: FontFamily.Nunito.semiBold.font(size: 22)
			]
		)
		authorsTitleLabel.snp.makeConstraints { make in
			make.leading.equalToSuperview().offset(24)
			make.top.equalToSuperview().offset(16)
		}
		authorsCollectionView.backgroundColor = .clear
		authorsCollectionView.snp.makeConstraints { make in
			make.leading.trailing.equalToSuperview()
			make.height.equalTo(130)
			make.top.equalTo(authorsTitleLabel.snp.bottom).offset(8)
		}
	}
	
	func setupUI() {
		[topArtworkImageView, navbar, titleLabel, contentScrollView]
			.forEach(view.addSubview)
		
		setupTopArtwork()
		setupNavbar()
		setupTitleLabel()
		setupContentScrollView()
	}
	
	func configure(with viewModel: DiscoverControllerViewModel) {
		
		let isLoading = viewModel.output.data.map { value -> Bool in
			if case .loading = value {
				return true
			} else {
				return false
			}
		}
		
		let data = viewModel.output.data
			.compactMap { value -> DiscoverData? in
				if case .item(let item) = value {
					return item
				} else {
					return nil
				}
			}
			.distinctUntilChanged()
		
		data
			.map { $0.authors }
			.map { array in return array.map(AuthorCellViewModel.init) }
			.map(Section.init)
			.map(toArray)
			.bind(to: authorsCollectionView.rx.items(dataSource: authorsCollectionViewDataSource()))
			.disposed(by: disposebag)
		
		let errors = viewModel.output.data
			.compactMap { value -> HashableWrapper<Discover.Error>? in
				if case .error(let wrapped) = value {
					return wrapped
				} else {
					return nil
				}
			}
			.distinctUntilChanged()
		
	}
	
	private func authorsCollectionViewDataSource() -> RxCollectionViewSectionedReloadDataSource<Section<AuthorCellViewModel>> {
		return RxCollectionViewSectionedReloadDataSource { ds, cv, indexPath, item in
			let cell: CircleImageAndTitleCellCell = cv.dequeueReusableCell(forIndexPath: indexPath)
			cell.configure(with: item)
			return cell
		}
	}
}

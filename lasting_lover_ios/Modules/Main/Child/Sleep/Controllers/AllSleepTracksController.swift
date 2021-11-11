//
//  AllSleepTracksController.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 08.11.2021.
//

import UIKit
import RxSwift
import RxDataSources

class AllSleepTracksController: ViewController<BackgroundImageView> {
	
	let viewModel: AllSleepTracksControllerViewModel
	private let disposeBag = DisposeBag()
	
	let navbar = BackButtonNavbarView()
	let titleLabel = UILabel()
	let activityIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
	
	lazy var contentCollectionView: UICollectionView = {
		let layout = UICollectionViewFlowLayout()
		layout.scrollDirection = .vertical
		layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 68)
		layout.minimumLineSpacing = 16
		let cv = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
		cv.registerClass(StoryCell.self)
		return cv
	}()
	
	init(viewModel: AllSleepTracksControllerViewModel) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	deinit {
		print("\(self) deinit")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupUI()
		configure(with: viewModel)
	}
	
	private func setupUI() {
		[navbar, titleLabel, contentCollectionView, activityIndicatorView].forEach(view.addSubview)
		navbar.snp.makeConstraints { make in
			make.leading.trailing.equalToSuperview()
			make.top.equalTo(view.safeAreaLayoutGuide)
			make.height.equalTo(44)
		}
		titleLabel.snp.makeConstraints { make in
			make.top.equalTo(navbar.snp.bottom)
			make.leading.equalToSuperview().offset(24)
		}
		titleLabel.attributedText = NSAttributedString(
			string: L10n.allTracks,
			attributes: [.font: FontFamily.Nunito.bold.font(size: 36),
										.foregroundColor: Asset.Colors.white.color]
		)
		contentCollectionView.backgroundColor = .clear
		contentCollectionView.snp.makeConstraints { make in
			make.leading.trailing.equalToSuperview()
			make.top.equalTo(titleLabel.snp.bottom).offset(8)
			make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-8)
		}
		activityIndicatorView.snp.makeConstraints { make in
			make.center.equalTo(contentCollectionView)
		}
	}
	
	func configure(with viewModel: AllSleepTracksControllerViewModel) {
		
		let data = viewModel.output.contents.share(replay: 1, scope: .whileConnected)
		
		data
			.subscribe(onNext: { [weak self] value in
				if case .loading = value {
					self?.activityIndicatorView.isHidden = false
					self?.activityIndicatorView.startAnimating()
				} else {
					self?.activityIndicatorView.isHidden = true
					self?.activityIndicatorView.stopAnimating()
				}
			})
			.disposed(by: disposeBag)
		
		data
			.compactMap { l -> [Section<StoryCellViewModel>]? in
				if case .item(let item) = l {
					return item
				} else {
					return nil
				}
			}
			.bind(to: contentCollectionView.rx.items(dataSource: datasource()))
			.disposed(by: disposeBag)
		
		data
			.subscribe(onNext: { [weak self] value in
				if case .error(let wrapped) = value {
					self?.presentError(wrapped.value)
				}
			})
			.disposed(by: disposeBag)
		
		navbar.backButton.rx.tap
			.subscribe(viewModel.input.backTap)
			.disposed(by: disposeBag)
		
		contentCollectionView.rx.itemSelected
			.map { $0.item }
			.subscribe(viewModel.input.selectedItem)
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

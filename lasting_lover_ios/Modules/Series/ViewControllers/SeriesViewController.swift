//
//  SeriesViewController.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 13.11.2021.
//

import UIKit
import RxSwift
import RxDataSources
import UNILibCore

class SeriesViewController: ViewController<BackgroundImageView> {
	
	let navbarView = BackButtonNavbarView()
  let playButton = UIButton()
	let imageView = UIImageView()
  let titleLabelTapGesture = UITapGestureRecognizer(target: nil, action: nil)
	let titleLabel = UILabel()
	let subtitleLabel = UILabel()
	
	let contentScrollView = VerticalScrollingView()
	
	let authorsCollectionView: UICollectionView = {
		let layout = UICollectionViewFlowLayout()
		layout.scrollDirection = .horizontal
		layout.minimumLineSpacing = 24
		layout.minimumInteritemSpacing = 24
		layout.itemSize = CGSize(width: 60, height: 90)
    layout.sectionInset = .init(top: 0, left: 16, bottom: 0, right: 16)
		let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
		cv.registerClass(CircleImageAndTitleCellCell.self)
		return cv
	}()
  
  let durationLabel = UILabel()
  let progressBar = SpicyDataView()
	
	let categoriesCollectionView: UICollectionView = {
		let layout = UICollectionViewFlowLayout()
		layout.scrollDirection = .horizontal
		layout.minimumLineSpacing = 8
		layout.minimumInteritemSpacing = 8
    layout.estimatedItemSize = CGSize(width: 60, height: 90)
    layout.sectionInset = .init(top: 0, left: 16, bottom: 0, right: 16)
		let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
    cv.registerClass(SeriesCategoryCell.self)
		return cv
	}()
	
	let activityIndicator = UIActivityIndicatorView(style: .large)
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
      playButton,
			contentScrollView
		]
			.forEach(view.addSubview)
		
		contentScrollView.snp.makeConstraints { make in
			make.leading.trailing.equalToSuperview()
			make.bottom.equalTo(view.safeAreaLayoutGuide)
			make.top.equalTo(imageView.snp.bottom).offset(8)
		}
    
    [
      titleLabel,
      subtitleLabel,
      authorsCollectionView,
      durationLabel,
      progressBar,
      categoriesCollectionView,
      listTitleLabel,
			listStackView,
			activityIndicator
		]
			.forEach(contentScrollView.containerView.addSubview)
		
		setupNavbarView()
    
    playButton.setImage(Asset.Images.playInWhiteCircle.image, for: .normal)
    playButton.snp.makeConstraints { make in
      make.center.equalTo(imageView)
      make.size.equalTo(150)
    }
    
		imageView.contentMode = .scaleAspectFit
		imageView.snp.makeConstraints { make in
			make.centerX.equalToSuperview()
      make.top.equalTo(view.safeAreaLayoutGuide).offset(-30)
      make.height.equalTo(296)
      make.leading.trailing.equalToSuperview().inset(40)
		}

		titleLabel.textColor = .white
		titleLabel.font = FontFamily.Nunito.semiBold.font(size: 22)
		titleLabel.snp.makeConstraints { make in
			make.leading.trailing.equalToSuperview().inset(30)
      make.top.equalToSuperview().offset(8)
		}

    subtitleLabel.isUserInteractionEnabled = true
    subtitleLabel.addGestureRecognizer(titleLabelTapGesture)
		subtitleLabel.numberOfLines = 0
		subtitleLabel.snp.makeConstraints { make in
			make.leading.trailing.equalToSuperview().inset(30)
			make.top.equalTo(titleLabel.snp.bottom).offset(8)
		}
		authorsCollectionView.backgroundColor = .clear
		authorsCollectionView.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview().inset(16)
      make.top.equalTo(subtitleLabel.snp.bottom)
			make.height.equalTo(110)
		}
    
    durationLabel.textColor = .white
    durationLabel.font = FontFamily.Nunito.semiBold.font(size: 17)
    durationLabel.snp.makeConstraints { make in
      make.top.equalTo(authorsCollectionView.snp.bottom).offset(16)
      make.leading.trailing.equalToSuperview().inset(24)
    }
    
//    progressBar.setProgress(value: 0.5)
    progressBar.snp.makeConstraints { make in
      make.top.equalTo(durationLabel.snp.bottom).offset(24)
      make.leading.trailing.equalToSuperview().inset(24)
      make.height.equalTo(44)
    }
		
		categoriesCollectionView.backgroundColor = .clear
		categoriesCollectionView.snp.makeConstraints { make in
			make.leading.trailing.equalToSuperview()
			make.top.equalTo(progressBar.snp.bottom).offset(16)
			make.height.equalTo(36)
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
			make.top.equalTo(categoriesCollectionView.snp.bottom).offset(16)
		}
		
		listStackView.axis = .vertical
		listStackView.spacing = 16
		listStackView.snp.makeConstraints { make in
			make.leading.trailing.equalToSuperview().inset(24)
			make.top.equalTo(listTitleLabel.snp.bottom).offset(16)
			make.bottom.equalToSuperview().offset(-8)
		}
		activityIndicator.snp.makeConstraints { make in
			make.center.equalTo(listStackView)
		}
	}
	
  private func configure(with viewModel: SeriesControllerViewModel) {
    playButton.rx.tap
      .subscribe(viewModel.input.playFirstStory)
      .disposed(by: disposeBag)
    viewModel.output.spicyData
      .subscribe(onNext: { [unowned self] value in
        if let value = value {
          self.progressBar.setSpicyData(value: value)
        } else {
          self.progressBar.isHidden = true
          self.categoriesCollectionView.snp.remakeConstraints { make in
            make.top.equalTo(self.durationLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(36)
          }
        }
      })
      .disposed(by: disposeBag)
    viewModel.output.durationString
      .map(Optional.init)
      .subscribe(durationLabel.rx.text)
      .disposed(by: disposeBag)
    titleLabelTapGesture.rx.event
      .map(toVoid)
      .subscribe(viewModel.input.expandDesriptionTap)
      .disposed(by: disposeBag)
		viewModel.output.image
			.map(Optional.init)
			.subscribe(imageView.rx.image)
			.disposed(by: disposeBag)
		titleLabel.text = viewModel.output.title
    viewModel.output.subtitle
      .map(Optional.init)
      .subscribe(subtitleLabel.rx.attributedText)
      .disposed(by: disposeBag)
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
			.subscribe(onNext: { [unowned self, unowned viewModel] cells in
				self.cells = cells
				cells.enumerated().forEach { idx, cell in
					self.listStackView.addArrangedSubview(cell)
					cell.snp.makeConstraints { make in
						make.leading.trailing.equalToSuperview()
						make.height.equalTo(68)
					}
					let gesture = UITapGestureRecognizer(target: nil, action: nil)
					cell.contentView.addGestureRecognizer(gesture)
					gesture.rx.event
						.compactMap { _ in IndexPath(row: idx, section: 0) }
						.subscribe(viewModel.input.storySelectedAtIndex)
						.disposed(by: self.disposeBag)
				}
			})
			.disposed(by: disposeBag)
		
		content
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
		
		content
			.map { value -> Bool in
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
			.disposed(by: disposeBag)
		
		authorsCollectionView.rx.itemSelected
			.subscribe(viewModel.input.authorSelectedAtIndex)
			.disposed(by: disposeBag)
		categoriesCollectionView.rx.itemSelected
			.subscribe(viewModel.input.categorySelectedAtIndex)
			.disposed(by: disposeBag)
	}
	
	func categoriesCollectionViewDataSource() -> RxCollectionViewSectionedReloadDataSource<Section<SleepCategoryCellViewModel>> {
		return .init { ds, cv, indexPath, item in
			let cell: SeriesCategoryCell = cv.dequeueReusableCell(forIndexPath: indexPath)
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

//
//  SettingsViewController.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 05.10.2021.
//

import UIKit
import RxSwift
import RxDataSources

class SettingsViewController: ViewController<BackgroundImageView> {
  let navbar = BackButtonNavbarView()

  let titleLabel = UILabel()
	let collectionView: UICollectionView = {
		let layout = UICollectionViewFlowLayout()
		layout.scrollDirection = .vertical
		layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 44)
		let cv = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
		cv.registerClass(SettingsCell.self)
		return cv
	}()

  let disposeBag = DisposeBag()
  let viewModel: SettingsControllerViewModel

  init(viewModel: SettingsControllerViewModel) {
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

  fileprivate func setupTitleLabel() {
    titleLabel.attributedText = NSAttributedString(
      string: L10n.settings,
      attributes: [
        .foregroundColor: Asset.Colors.white.color,
        .font: FontFamily.Nunito.bold.font(size: 36)
      ]
    )
    titleLabel.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(24)
      make.top.equalTo(navbar.snp.bottom).offset(4)
    }
  }

  fileprivate func setupNavBar() {
    navbar.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview()
      make.top.equalTo(view.safeAreaLayoutGuide)
      make.height.equalTo(44)
    }
  }

  func setupUI() {
    [navbar, titleLabel, collectionView].forEach(view.addSubview)

    setupNavBar()
    setupTitleLabel()
		collectionView.backgroundColor = .clear
		collectionView.snp.makeConstraints { make in
			make.leading.trailing.equalToSuperview()
			make.top.equalTo(titleLabel.snp.bottom).offset(16)
			make.bottom.equalTo(view.safeAreaLayoutGuide)
		}
  }

  func configure(with viewModel: SettingsControllerViewModel) {
		viewModel.output.contents
			.bind(to: collectionView.rx.items(dataSource: dataSource()))
			.disposed(by: disposeBag)
		collectionView.rx.itemSelected
			.subscribe(viewModel.input.settingsItemSelectedAtIndex)
			.disposed(by: disposeBag)
	}
	
	func dataSource() -> RxCollectionViewSectionedReloadDataSource<Section<SettingsCellViewModel>> {
		return .init { ds, cv, indexPath, item in
			let cell: SettingsCell = cv.dequeueReusableCell(forIndexPath: indexPath)
			cell.configure(with: item)
			return cell
		}
	}
}

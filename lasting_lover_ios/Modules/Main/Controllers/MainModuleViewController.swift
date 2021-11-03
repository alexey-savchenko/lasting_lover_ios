//
//  MainModuleViewController.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 03.10.2021.
//

import UIKit
import RxSwift
import SwiftUI
import UNILibCore

class MainModuleViewController: UIViewController {
  let toolbar = ToolBar()

  let discoverItem = _ToolBarItem(
    image: Asset.Images.headphoneFill.image,
    text: L10n.mainTabDiscover,
    selectedColors: (
      Asset.Colors.tabColor0.color,
      Asset.Colors.tabColor1.color
    ),
    deselectedColors: (
      Asset.Colors.white.color.withAlphaComponent(0.5),
      Asset.Colors.white.color.withAlphaComponent(0.5)
    )
  )
  let sleepItem = _ToolBarItem(
    image: Asset.Images.moon.image,
    text: L10n.mainTabSleep,
    selectedColors: (
      Asset.Colors.tabColor0.color,
      Asset.Colors.tabColor1.color
    ),
    deselectedColors: (
      Asset.Colors.white.color.withAlphaComponent(0.5),
      Asset.Colors.white.color.withAlphaComponent(0.5)
    )
  )

  lazy var discoverViewController = DiscoverViewController(
		viewModel: DiscoverControllerViewModel(
			state: appStore.stateObservable.map { $0.mainModuleState.discoverState }.distinctUntilChanged(),
			dispatch: MainModule.Action.discoverAction <*> App.Action.mainModuleAction <*> appStore.dispatch
		)
  )
  lazy var sleepViewController = SleepViewController(
    viewModel: SleepControllerViewModel()
  )

  let viewModel: MainControllerViewModel

  private let disposeBag = DisposeBag()

  init(viewModel: MainControllerViewModel) {
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
    view.addSubview(toolbar)
    toolbar.snp.makeConstraints { make in
      make.leading.trailing.bottom.equalToSuperview()
    }
    toolbar.set(items: [discoverItem, sleepItem])
    [discoverItem, sleepItem].forEach { i in
      i.snp.makeConstraints { make in
        make.width.equalTo(60)
        make.height.equalTo(42)
      }
    }

    [discoverViewController, sleepViewController].forEach { c in
      add(c)
      c.view.snp.makeConstraints { make in
        make.top.leading.trailing.equalToSuperview()
        make.bottom.equalTo(toolbar.snp.top)
      }
    }
    view.bringSubviewToFront(toolbar)
  }

  private func configure(with viewModel: MainControllerViewModel) {
    viewModel.output.selectedTabIndex
      .subscribe(onNext: { value in
        self.toolbar.items.enumerated().forEach { idx, item in
          item.setSelected(idx == value)
        }
        [
          self.discoverViewController,
          self.sleepViewController
        ].enumerated().forEach { idx, item in
          item.view.isHidden = idx != value
        }
      })
      .disposed(by: disposeBag)
    self.toolbar.tapWithIndex
      .subscribe(viewModel.input.selectedTabWithIndex)
      .disposed(by: disposeBag)

    discoverViewController.navbar.rightButton.rx.tap
      .subscribe(viewModel.input.settingsButtonTap)
      .disposed(by: disposeBag)
    sleepViewController.navbar.rightButton.rx.tap
      .subscribe(viewModel.input.settingsButtonTap)
      .disposed(by: disposeBag)
  }
}

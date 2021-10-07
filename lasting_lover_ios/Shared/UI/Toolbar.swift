//
//  BottomToolBar.swift
//  App
//
//  Created by Vadym Yakovlev on 27.02.2020.
//  Copyright © 2020 Vadym Yakovlev. All rights reserved.
//

import UIKit
import RxSwift

class ToolBar: UIView {
  private let containerStackView = UIStackView()
  private let tapWithIndexSubject = PublishSubject<Int>()
  private let disposeBag = DisposeBag()

  var items: [ToolbarItemProtocol] {
    containerStackView
      .arrangedSubviews
      .compactMap { $0 as? ToolbarItemProtocol }
  }

  var tapWithIndex: Observable<Int> {
    tapWithIndexSubject.asObservable()
  }

  override init(frame: CGRect) {
    super.init(frame: frame)

    configure()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func set(items: [ToolbarItemProtocol]) {
    let views = containerStackView.arrangedSubviews
    views.forEach(containerStackView.removeArrangedSubview)
    views.forEach { $0.removeFromSuperview() }
    items.forEach { item in
      containerStackView.addArrangedSubview(item)
      item.snp.makeConstraints { make in
        make.width.equalTo(60)
      }
    }

    configureBindings()
  }

  override func layoutSubviews() {
    super.layoutSubviews()

    items.forEach { $0.setNeedsDisplay() }
  }
}

private extension ToolBar {
  func configure() {
    backgroundColor = Asset.Colors.tabBarBackground.color
    configureContainerStackView()
  }

  func configureContainerStackView() {
    containerStackView.axis = .horizontal
    containerStackView.spacing = 80
    containerStackView.distribution = .equalSpacing
    containerStackView.alignment = .center

    addSubview(containerStackView)
    containerStackView.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalToSuperview()
//      make.leading.trailing.equalToSuperview().inset(36)
      make.height.equalTo(49)
      make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
    }
  }

  func configureBindings() {
    Observable
      .merge(
        items
          .enumerated()
          .map { index, item in
            item.tap.map { index }
          }
      )
      .subscribe(tapWithIndexSubject)
      .disposed(by: disposeBag)
  }
}

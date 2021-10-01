//
//  PrimaryButton.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 01.10.2021.
//

import UIKit
import RxSwift

class Button: UIButton {
  
  enum Style {
    case primary
    case secondary
  }
  
  enum State {
    case `default`
    case pressed
  }
  
  let style: Style
  let title: String
  
  var _state = State.default
  private let disposeBag = DisposeBag()
  
  init(style: Style, title: String) {
    self.style = style
    self.title = title
    
    super.init(frame: .zero)
    
    Observable
      .merge(
        rx
          .controlEvent(.touchDown)
          .map { _ in State.pressed },
        rx
          .controlEvent(.touchUpInside)
          .map { _ in State.default }
      )
      .subscribe(onNext: { [weak self] state in
        self?.renderState(state)
      })
      .disposed(by: disposeBag)
    
    clipsToBounds = true
    layer.borderColor = Asset.Colors.white.color.cgColor
    renderState(.default)
  }
  
  func renderState(_ state: State) {
    self._state = state
    switch state {
    case .default:
      layer.borderWidth = 0
      renderStyle(style)
    case .pressed:
      backgroundColor = Asset.Colors.gray.color
      layer.borderWidth = 1
      setAttributedTitle(
        NSAttributedString(
          string: title,
          attributes: [
            .foregroundColor: Asset.Colors.white.color,
            .font: FontFamily.Nunito.regular.font(size: 16)
          ]
        ),
        for: .normal
      )
    }
  }
  
  func renderStyle(_ style: Style) {
    switch style {
    case .primary:
      backgroundColor = Asset.Colors.button.color
      setAttributedTitle(
        NSAttributedString(
          string: title,
          attributes: [
            .foregroundColor: Asset.Colors.white.color,
            .font: FontFamily.Nunito.regular.font(size: 16)
          ]
        ),
        for: .normal
      )
    case .secondary:
      backgroundColor = Asset.Colors.white.color
      setAttributedTitle(
        NSAttributedString(
          string: title,
          attributes: [
            .foregroundColor: Asset.Colors.text.color,
            .font: FontFamily.Nunito.regular.font(size: 16)
          ]
        ),
        for: .normal
      )
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    layer.cornerRadius = bounds.height / 2
  }
}

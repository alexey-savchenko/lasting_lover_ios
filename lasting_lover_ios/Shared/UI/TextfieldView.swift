//
//  TextfieldVIew.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 01.10.2021.
//

import UIKit
import RxSwift
import RxCocoa

class TextfieldView: UIView {
  
  enum State {
    case `default`
    case focused
    case error
  }

  let textfield = UITextField()
  var state = State.default
  let placeholder: String
  
  let disposeBag = DisposeBag()
  
  init(placeholder: String) {
    self.placeholder = placeholder
    super.init(frame: .zero)
    
    setupUI()
    
    let stateObervable = textfield.rx
      .observe(UIControl.State.self, #keyPath(UITextField.state))
      .filterNil()
    
    let text = textfield.rx.text.filterNil()
    
    Observable
      .combineLatest(stateObervable, text)
      .subscribe(onNext: { [weak self] state, _ in
        if state == .focused {
          self?.render(.focused)
        } else {
          self?.render(.default)
        }
      })
      .disposed(by: disposeBag)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  fileprivate func setupTextfield() {
    textfield.font = FontFamily.Nunito.regular.font(size: 15)
    textfield.textColor = Asset.Colors.text.color
    addSubview(textfield)
    textfield.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview().offset(16)
      make.centerY.equalToSuperview()
      make.height.equalTo(28)
    }
  }
  
  func setupUI() {
    defer {
      render(.default)
    }
    
    clipsToBounds = true
    layer.cornerRadius = 14
    layer.borderWidth = 1
    
    setupTextfield()
  }
 
  func render(_ state: State) {
    self.state = state
    if !textfield.text!.isEmpty {
      layer.borderColor = Asset.Colors.white.color.cgColor
      backgroundColor = Asset.Colors.white.color
    } else {
      switch state {
      case .error:
        layer.borderColor = Asset.Colors.redError.color.cgColor
        backgroundColor = Asset.Colors.redPaleError.color
      case .default:
        layer.borderColor = Asset.Colors.white.color.cgColor
        backgroundColor = Asset.Colors.gray.color
        textfield.attributedPlaceholder = NSAttributedString(
          string: placeholder,
          attributes: [
            .foregroundColor: UIColor.white,
            .font: FontFamily.Nunito.regular.font(size: 15)
          ]
        )
      case .focused:
        layer.borderColor = Asset.Colors.white.color.cgColor
        backgroundColor = Asset.Colors.white.color
        textfield.attributedPlaceholder = NSAttributedString(
          string: placeholder,
          attributes: [
            .foregroundColor: UIColor.black.withAlphaComponent(0.6),
            .font: FontFamily.Nunito.regular.font(size: 15)
          ]
        )
      }
    }
  }
}

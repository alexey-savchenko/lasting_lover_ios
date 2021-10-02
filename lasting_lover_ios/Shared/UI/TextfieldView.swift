//
//  TextfieldVIew.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 01.10.2021.
//

import UIKit
import RxSwift
import RxCocoa

class TextfieldView: UIView, UITextFieldDelegate {
  
  enum State {
    case `default`
    case focused
    case error
  }

  let textfield = UITextField()
  var state = State.default
  let placeholder: String
  let isEditing = BehaviorSubject<Bool>(value: false)
  
  let disposeBag = DisposeBag()
  
  init(placeholder: String) {
    self.placeholder = placeholder
    super.init(frame: .zero)
    
    setupUI()
    
    textfield.delegate = self
    
    let text = textfield.rx.text.filterNil()
    
    Observable
      .combineLatest(isEditing, text)
      .subscribe(onNext: { [weak self] editing, _ in
        guard let self = self else { return }
        UIView.transition(with: self, duration: 0.1, options: .transitionCrossDissolve) {
          if editing {
            self.render(.focused)
          } else {
            self.render(.default)
          }
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
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    isEditing.onNext(true)
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    isEditing.onNext(false)
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
        backgroundColor = Asset.Colors.grayTransparent.color
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

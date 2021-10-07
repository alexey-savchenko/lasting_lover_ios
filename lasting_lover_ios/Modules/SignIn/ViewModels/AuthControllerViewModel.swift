//
//  AuthControllerViewModel.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 01.10.2021.
//

import Foundation
import RxSwift
import UNILibCore
import RxUNILib

class AuthControllerViewModel {
  struct Input {
    let submitTap: AnyObserver<Void>
    let email: AnyObserver<String>
    let password: AnyObserver<String>
    let modeSwitchTap: AnyObserver<Void>
  }

  private let submitTapSubject = PublishSubject<Void>()
  private let emailSubject = PublishSubject<String>()
  private let passwordSubject = PublishSubject<String>()
  private let modeSwitchTapSubject = PublishSubject<Void>()

  struct Output {
    let mode: Observable<AuthModuleLaunchMode>
    let submitEnabled: Observable<Bool>
    let isLoading: Observable<Bool>
  }

  let input: Input
  let output: Output

  private let disposeBag = DisposeBag()

  init(
    state: Observable<Auth.State>,
    dispatch: @escaping DispatchFunction<Auth.Action>
  ) {
    self.input = Input(
      submitTap: submitTapSubject.asObserver(),
      email: emailSubject.asObserver(),
      password: passwordSubject.asObserver(),
      modeSwitchTap: modeSwitchTapSubject.asObserver()
    )
    self.output = Output(
      mode: state.map { $0.mode }.distinctUntilChanged(),
      submitEnabled: state.map { $0.email.isNotEmpty && $0.password.isNotEmpty }.distinctUntilChanged(),
      isLoading: state.map { $0.isLoading }.distinctUntilChanged()
    )

    disposeBag
      .insert(
        submitTapSubject.subscribe(onNext: { dispatch(.submitEmailPass) }),
        emailSubject.subscribe(onNext: { dispatch(.setEmail(value: $0)) }),
        passwordSubject.subscribe(onNext: { dispatch(.setPassword(value: $0)) }),
        modeSwitchTapSubject
          .withLatestFrom(state.map { $0.mode })
          .subscribe(onNext: { currentMode in
            switch currentMode {
            case .signIn:
              dispatch(.setMode(value: .signUp))
            case .signUp:
              dispatch(.setMode(value: .signIn))
            }
          })
      )
  }
}

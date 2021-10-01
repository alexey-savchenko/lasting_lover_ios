//
//  SignInModuleCoordinator.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 30.09.2021.
//

import Foundation
import UNILibCore
import RxUNILib
import RxSwift
import UIKit

enum AuthModuleLaunchMode: Int, Hashable {
  case signIn
  case signUp
}

class AuthModuleCoordinator: RxBaseCoordinator<Void> {

  let navigationController: UINavigationController
  
  let store = RxStore<Auth.State, Auth.Action>(
    inputState: .default(mode: .signIn),
    middleware: [Auth.middleware],
    reducer: Auth.reducer
  )
  
  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }
  
  override func start() -> Observable<Void> {
    let startController = AuthTitleViewController()
    navigationController.setViewControllers([startController], animated: false)

    Observable
      .merge(
        [
          startController.signInButton.rx.tap.asObservable().map { AuthModuleLaunchMode.signIn },
          startController.signUpButton.rx.tap.asObservable().map { _ in return AuthModuleLaunchMode.signUp }
        ]
      )
      .do(onNext: { [unowned self] mode in
        store.dispatch(.setMode(value: mode))
      })
      .flatMap { [unowned self] mode in
        presentAuthModule(
          state: store.stateObservable,
          dispatch: store.dispatch,
          navigationController: navigationController
        )
      }
      .subscribe()
      .disposed(by: disposeBag)
    
    return .never()
  }
  
  func presentAuthModule(
    state: Observable<Auth.State>,
    dispatch: @escaping DispatchFunction<Auth.Action>,
    navigationController: UINavigationController
  ) -> Observable<Void?> {
    let viewModel = AuthControllerViewModel(state: state, dispatch: dispatch)
    let controller = AuthViewController(viewModel: viewModel)
    navigationController.pushViewController(controller, animated: true)
    
    let dismiss = controller.navbarView.backButton.rx.tap
      .do(onNext: { navigationController.popViewController(animated: true) })
      .map { _ -> Void? in nil }
    return dismiss
  }
}

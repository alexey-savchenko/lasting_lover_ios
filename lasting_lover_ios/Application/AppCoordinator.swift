//
//  AppCoordinator.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 30.09.2021.
//

import UIKit
import RxUNILib
import RxSwift

let appStore = RxStore<AppState, AppAction>(
  inputState: AppState.default(),
  middleware: [appMiddleware],
  reducer: appReducer
)

class AppCoordinator: RxBaseCoordinator<Never> {
  
  let window: UIWindow
  let navigationController = UINavigationController(rootViewController: SplashViewController())
  
  init(window: UIWindow) {
    self.window = window
  }
  
  override func start() -> Observable<Never> {
    
    window.rootViewController = navigationController
    navigationController.setNavigationBarHidden(true, animated: false)
    window.makeKeyAndVisible()
    
    presentMainModule(controller: navigationController)
      .subscribe()
      .disposed(by: disposeBag)
//    if Current.localStorageService().userToken.isEmpty {
//      presentAuthModule(controller: navigationController)
//        .flatMap { _ in
//          return self.presentDiscoverModule(controller: self.navigationController)
//        }
//        .subscribe()
//        .disposed(by: disposeBag)
//    } else {
//
//    }
  
    return .never()
  }
  
  func presentAuthModule(controller: UINavigationController) -> Observable<Void> {
    let coordinator = AuthModuleCoordinator(navigationController: controller)
    return coordinate(to: coordinator)
  }
  
  func presentMainModule(controller: UINavigationController) -> Observable<Void> {
    let coordinator = MainModuleCoordinator(controller: controller)
    return coordinate(to: coordinator)
  }
}

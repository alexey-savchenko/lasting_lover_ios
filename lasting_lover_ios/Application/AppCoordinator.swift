//
//  AppCoordinator.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 30.09.2021.
//

import UIKit
import RxUNILib
import RxSwift

let appStore = RxStore<App.State, App.Action>(
	inputState: App.State.default(),
	middleware: [App.middleware],
	reducer: App.reducer
)

class AppCoordinator: RxBaseCoordinator<Never> {
  let window: UIWindow
  let navigationController = UINavigationController(rootViewController: SplashViewController())

  init(window: UIWindow) {
    self.window = window
  }

  override func start() -> Observable<Never> {
    window.rootViewController = navigationController
    navigationController.navigationBar.isHidden = true
    window.makeKeyAndVisible()
		
		if !Current.localStorageService().shownOnboarding {
			presentWelcomeModule(controller: navigationController)
				.do(onNext: {
					Current.localStorageService().shownOnboarding = true
				})
				.flatMap {
					return self.presentMainModule(controller: self.navigationController)
				}
				.subscribe()
				.disposed(by: disposeBag)
		} else {
			presentMainModule(controller: navigationController)
				.subscribe()
				.disposed(by: disposeBag)
		}

    return .never()
  }
	
	func presentWelcomeModule(controller: UINavigationController) -> Observable<Void> {
		let coordinator = WelcomeModuleCoordinator(presentingController: controller)
		return coordinate(to: coordinator)
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

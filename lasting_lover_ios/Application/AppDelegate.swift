//
//  AppDelegate.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 29.09.2021.
//

import UIKit
import RxSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  var appCoordinator: AppCoordinator!
  private let disposeBag = DisposeBag()

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    window = UIWindow(frame: UIScreen.main.bounds)
    
    window?.rootViewController = PlayerController(
      viewModel: PlayerControllerViewModel(
        state: Player.mockStore.stateObservable,
        dispatch: Player.mockStore.dispatch
      )
    )
    window?.makeKeyAndVisible()
    
    //    appCoordinator = AppCoordinator(window: window!)
    //    appCoordinator.start().subscribe().disposed(by: disposeBag)
    
//    let c = SnapshotController<PlayerProgressBarView>()
//    (c.content as! PlayerProgressBarView)
//    window?.rootViewController = c
//    window?.makeKeyAndVisible()
    
    return true
  }
}

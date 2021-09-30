//
//  AppCoordinator.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 30.09.2021.
//

import UIKit
import RxUNILib
import RxSwift

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
    
    return .never()
  }
}

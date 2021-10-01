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

enum AuthModuleLaunchMode {
  case signIn
  case signUp
}

class AuthModuleCoordinator: RxBaseCoordinator<Void> {

  let controller: UINavigationController
  
  init(controller: UINavigationController) {
    self.controller = controller
  }
  
  override func start() -> Observable<Void> {
    fatalError()
  }
}

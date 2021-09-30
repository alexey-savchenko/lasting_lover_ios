//
//  MainModuleCoordinator.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 30.09.2021.
//

import RxUNILib
import RxSwift
import UIKit

class MainModuleCoordinator: RxBaseCoordinator<Void> {
  
  override func start() -> Observable<Void> {
    return .never()
  }
  
}

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
  
  let navigationController: UINavigationController
  
  init(controller: UINavigationController) {
    self.navigationController = controller
  }
  
  override func start() -> Observable<Void> {
    
//    let mainController = MainModuleViewController(viewModel: MainControllerViewModel(state: <#T##Observable<AppState>#>, dispatch: <#T##DispatchFunction<AppAction>##DispatchFunction<AppAction>##(AppAction) -> Void#>))
//    navigationController.setViewControllers([mainController], animated: false)
    return .never()
  }
  
}

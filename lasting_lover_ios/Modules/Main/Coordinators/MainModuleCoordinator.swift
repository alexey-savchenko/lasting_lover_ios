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
    
    let viewModel = MainControllerViewModel(state: appStore.stateObservable, dispatch: appStore.dispatch)
    let mainController = MainModuleViewController(viewModel: viewModel)
    navigationController.setViewControllers([mainController], animated: false)
    
    viewModel.output.settingsButtonTap
      .flatMap { _ in
        self.presentSettingsModule(navigationController: self.navigationController)
      }
      .subscribe()
      .disposed(by: disposeBag)
    
    return .never()
  }
  
  func presentSettingsModule(navigationController: UINavigationController) -> Observable<Void> {
    let coordinator = SettingsModuleCoordinator(navigationController: navigationController)
    return coordinate(to: coordinator)
  }
}

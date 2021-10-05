//
//  SettingsModuleCoordinator.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 05.10.2021.
//

import UIKit
import RxUNILib
import RxSwift

class SettingsModuleCoordinator: RxBaseCoordinator<Void> {
  
  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }
  
  let navigationController: UINavigationController
  
  override func start() -> Observable<Void> {
    
    let viewModel = SettingsControllerViewModel()
    let controller = SettingsViewController(viewModel: viewModel)
    navigationController.pushViewController(controller, animated: true)
    
    return controller.navbar.backButton.rx.tap
      .do(onNext: { [unowned navigationController] _ in
        navigationController.popViewController(animated: true)
      })
  }
}

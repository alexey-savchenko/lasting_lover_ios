//
//  SettingsModuleCoordinator.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 05.10.2021.
//

import UIKit
import RxUNILib
import RxSwift
import UNILibCore

class SettingsModuleCoordinator: RxBaseCoordinator<Void> {
  
  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }
  
  let navigationController: UINavigationController
  let finishFlow = PublishSubject<Void>()
  
  override func start() -> Observable<Void> {
    
    let viewModel = SettingsControllerViewModel()
    let controller = SettingsViewController(viewModel: viewModel)
    
    navigationController.interactivePopGestureRecognizer!.rx
      .observeWeakly(UIGestureRecognizer.State.self, #keyPath(UIGestureRecognizer.state))
      .filterNil()
      .filter {  state in
        state == .ended
      }
      .filter { [unowned self, unowned controller] _ in
        !self.navigationController.viewControllers.contains(controller)
      }
      .map(toVoid)
      .subscribe(finishFlow)
      .disposed(by: disposeBag)

    navigationController.pushViewController(controller, animated: true)
    
    let backButtonTap: Observable<Void> = controller.navbar.backButton.rx.tap
      .do(onNext: { [unowned navigationController] _ in
        navigationController.popViewController(animated: true)
      })
      .asObservable()
    
    return Observable
      .merge(backButtonTap, finishFlow)
      .debug()
  }
  
//  func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
//    return true
//  }
}

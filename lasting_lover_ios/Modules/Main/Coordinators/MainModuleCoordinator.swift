//
//  MainModuleCoordinator.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 30.09.2021.
//

import RxUNILib
import RxSwift
import UIKit
import UNILibCore

class MainModuleCoordinator: RxBaseCoordinator<Void> {
  let navigationController: UINavigationController

  init(controller: UINavigationController) {
    self.navigationController = controller
  }

  override func start() -> Observable<Void> {
    let viewModel = MainControllerViewModel(
			state: appStore.stateObservable.map { $0.mainModuleState },
			dispatch: App.Action.mainModuleAction <*> appStore.dispatch
		)
    let mainController = MainModuleViewController(viewModel: viewModel)
    navigationController.setViewControllers([mainController], animated: false)

    viewModel.output.settingsButtonTap
      .flatMap { _ in
        self.presentSettingsModule(navigationController: self.navigationController)
      }
      .subscribe()
      .disposed(by: disposeBag)
		
		mainController.sleepViewController.featuredStoriesSeeAllButton.rx.tap
			.bind {
				self.presentAllSleepStoriesScreen(navigationContoller: self.navigationController)
			}
			.disposed(by: disposeBag)

    return .never()
  }
	
	func presentAllSleepStoriesScreen(navigationContoller: UINavigationController) {
		let viewModel = AllSleepTracksControllerViewModel(
			state: appStore.stateObservable.map { $0.mainModuleState.sleepState },
			dispatch: MainModule.Action.sleepAction <*> App.Action.mainModuleAction <*> appStore.dispatch
		)
		let contoller = AllSleepTracksController(viewModel: viewModel)
		navigationController.pushViewController(contoller, animated: true)
	}

  func presentSettingsModule(navigationController: UINavigationController) -> Observable<Void> {
    let coordinator = SettingsModuleCoordinator(navigationController: navigationController)
    return coordinate(to: coordinator)
  }
}

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
		
		let presentedAllSleepStories = mainController.sleepViewController.featuredStoriesSeeAllButton.rx.tap
			.flatMap {
				return self.presentAllSleepStoriesScreen(navigationContoller: self.navigationController)
			}
			.share()
//			.subscribe(onNext: { either in
//				switch either {
//				case .right(let value):
//				case .left(value: <#T##Void#>)
//				}
//			})
//			.disposed(by: disposeBag)
		
		presentedAllSleepStories
			.subscribe(onNext: { [unowned self] v in
				if case .left = v {
					self.navigationController.popViewController(animated: true)
				}
			})
			.disposed(by: disposeBag)

    return .never()
  }
	
	func presentAllSleepStoriesScreen(navigationContoller: UINavigationController) -> Observable<Either<Void, Story>> {
		let viewModel = AllSleepTracksControllerViewModel(
			state: appStore.stateObservable.map { $0.mainModuleState.sleepState },
			dispatch: MainModule.Action.sleepAction <*> App.Action.mainModuleAction <*> appStore.dispatch
		)
		let contoller = AllSleepTracksController(viewModel: viewModel)
	
		navigationController.pushViewController(contoller, animated: true)
		
		let result = Observable
			.merge(
				viewModel.output.backTap.map { Either<Void, Story>.left(value: Void()) },
				viewModel.output.selectedStory.map { value in Either<Void, Story>.right(value: value) }
			)
		
		return result
	}

  func presentSettingsModule(navigationController: UINavigationController) -> Observable<Void> {
    let coordinator = SettingsModuleCoordinator(navigationController: navigationController)
    return coordinate(to: coordinator)
  }
}

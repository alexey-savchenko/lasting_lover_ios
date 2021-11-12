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
		
		let presentedSleepCategoryStories = mainController.sleepViewController.viewModel.output.selectedCategory
			.debug()
			.flatMapLatest { category in
				return self.presentCategoryStoriesScreen(navigationContoller: self.navigationController, category: category)
			}
			.share(replay: 1, scope: .whileConnected)
		
		Observable
			.merge(presentedAllSleepStories, presentedSleepCategoryStories)
			.subscribe(onNext: { [unowned self] v in
				if case .left = v {
					self.navigationController.popViewController(animated: true)
				}
			})
			.disposed(by: disposeBag)
		
		let selectedFeaturedSleepStory = mainController.sleepViewController.viewModel.output.selectedFeatuedStory
		
		Observable
			.merge(
				presentedAllSleepStories.compactMap { $0.right },
				presentedSleepCategoryStories.compactMap { $0.right },
				selectedFeaturedSleepStory
			)
			.withLatestFrom(appStore.stateObservable) { ($0, $1) }
			.flatMap { story, state -> Observable<Story> in
//				if story.paid == 1 && !state.settingsState.subscriptionActive {
//
//				} else {
					return Observable.just(story)
//				}
			}
			.flatMap { story in
				self.presentPlayerModule(navigationContoller: self.navigationController, story: story)
			}
			.subscribe()
			.disposed(by: disposeBag)
		
    return .never()
  }
	
	func presentPlayerModule(
		navigationContoller: UINavigationController,
		story: Story
	) -> Observable<Void> {
		let coordinator = PlayerModuleCoordinator(
			navigationController: navigationController,
			playerItem: PlayerItem(
				title: story.name,
				authorName: story.authorName,
				artworkURL: story.artworkURL,
				contentURL: story.contentURL,
				id: story.id
			)
		)
		
		return coordinate(to: coordinator)
	}
	
	func presentCategoryStoriesScreen(
		navigationContoller: UINavigationController,
		category: Category
	) -> Observable<Either<Void, Story>> {
		let viewModel = SleepStoriesControllerViewModel(
			target: .forCategory(value: category),
			state: appStore.stateObservable.map { $0.mainModuleState.sleepState },
			dispatch: MainModule.Action.sleepAction <*> App.Action.mainModuleAction <*> appStore.dispatch
		)
		let contoller = SleepStoriesController(viewModel: viewModel)
	
		navigationController.pushViewController(contoller, animated: true)
		
		let result = Observable
			.merge(
				viewModel.output.backTap.map { Either<Void, Story>.left(value: Void()) },
				viewModel.output.selectedStory.map { value in Either<Void, Story>.right(value: value) }
			)
		
		return result
	}
	
	func presentAllSleepStoriesScreen(navigationContoller: UINavigationController) -> Observable<Either<Void, Story>> {
		let viewModel = SleepStoriesControllerViewModel(
			target: .all,
			state: appStore.stateObservable.map { $0.mainModuleState.sleepState },
			dispatch: MainModule.Action.sleepAction <*> App.Action.mainModuleAction <*> appStore.dispatch
		)
		let contoller = SleepStoriesController(viewModel: viewModel)
	
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

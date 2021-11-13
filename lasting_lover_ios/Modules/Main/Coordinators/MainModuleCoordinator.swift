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

		mainController.discoverViewController.viewModel.output.selectedAuthor
			.flatMap { author in
				return self.presentAuthorContent(
					navigationController: self.navigationController,
					author: author
				)
			}
			.subscribe()
			.disposed(by: disposeBag)
		
		mainController
			.discoverViewController.seeAllSeriesButton.rx.tap
			.flatMap {
				return self.presentAllSeriesScreen(
					navigationController: self.navigationController
				)
			}
			.compactMap { $0.right }
			.flatMap { series in
				return self.presentSeriesModule(
					series: series,
					navigationController: self.navigationController
				)
			}
			.subscribe()
			.disposed(by: disposeBag)
		
		mainController.discoverViewController.viewModel.output.selectedFeaturedSeries
			.flatMap { series in
				return self.presentSeriesModule(
					series: series,
					navigationController: self.navigationController
				)
			}
			.subscribe()
			.disposed(by: disposeBag)
		
		viewModel.output.settingsButtonTap
      .flatMap { _ in
        self.presentSettingsModule(navigationController: self.navigationController)
      }
      .subscribe()
      .disposed(by: disposeBag)
		
		let presentedAllSleepStories = mainController.sleepViewController.featuredStoriesSeeAllButton.rx.tap
			.flatMap {
				return self.presentStoriesScreen(
					navigationContoller: self.navigationController,
					target: .allSleepStories
				)
			}
			.share()
		
		let presentedSleepCategoryStories = mainController.sleepViewController.viewModel.output.selectedCategory
			.debug()
			.flatMapLatest { category in
				return self.presentStoriesScreen(
					navigationContoller: self.navigationController,
					target: .sleepStoriesForCategory(value: category)
				)
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
	
	func presentSeriesModule(series: Series, navigationController: UINavigationController) -> Observable<Void> {
		let coordinator = SeriesModuleCoordinator(navigationController: navigationController, series: series)
		return coordinate(to: coordinator)
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
	
	func presentAllSeriesScreen(navigationController: UINavigationController) -> Observable<Either<Void, Series>> {
		let viewModel = AllSeriesControllerViewModel(
			state: appStore.stateObservable.map { $0.mainModuleState.discoverState }.distinctUntilChanged(),
			dispatch: MainModule.Action.discoverAction <*> App.Action.mainModuleAction <*> appStore.dispatch
		)
		let controller = AllSeriesViewController(viewModel: viewModel)
		navigationController.pushViewController(controller, animated: true)
		
		let dismiss = controller.navbar.backButton.rx.tap.asObservable()
			.do(onNext: { [unowned navigationController] in
				navigationController.popViewController(animated: true)
			})
			.map { Either<Void, Series>.left(value: Void()) }
		let selectedSeries = viewModel.output.selectedSeries
			.map { Either<Void, Series>.right(value: $0) }
		
		return Observable.merge(dismiss, selectedSeries)
	}
	
	func presentAuthorContent(navigationController: UINavigationController, author: Author) -> Observable<Void> {
		let authorModuleCoordinator = AuthorModuleCoordinator(
			author: author,
			navigationController: navigationController
		)
		return coordinate(to: authorModuleCoordinator)
	}
	
	func presentStoriesScreen(
		navigationContoller: UINavigationController,
		target: StoryRequestTarget
	) -> Observable<Either<Void, Story>> {
		let viewModel = StoriesControllerViewModel(
			target: target,
			state: appStore.stateObservable,
			dispatch: appStore.dispatch
		)
		let contoller = StoriesController(viewModel: viewModel)
	
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

//
//  SeriesModuleCoordinator.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 13.11.2021.
//

import Foundation
import RxUNILib
import UIKit
import RxSwift
import UNILibCore

class SeriesModuleCoordinator: RxBaseCoordinator<Void> {
	
	let navigationController: UINavigationController
	let series: Series
	
	init(navigationController: UINavigationController, series: Series) {
		self.navigationController = navigationController
		self.series = series
	}
	
	override func start() -> Observable<Void> {
		
		let viewModel = SeriesControllerViewModel(
			series: series,
			state: appStore.stateObservable.map { $0.mainModuleState.discoverState }.distinctUntilChanged(),
			dispatch: MainModule.Action.discoverAction <*> App.Action.mainModuleAction <*> appStore.dispatch
		)
		let controller = SeriesViewController(viewModel: viewModel)
		
		navigationController.pushViewController(controller, animated: true)
		
		viewModel.output.selectedAuthor.flatMap { [unowned self] value in
			return self.presentAuthorContent(navigationController: self.navigationController, author: value)
		}
		.subscribe()
		.disposed(by: disposeBag)
		
		let presentedCategoryScreen = viewModel.output.categorySelected
			.flatMap { [unowned self] cat in
				return self.presentCategoryScreen(navigationContoller: self.navigationController, category: cat)
			}
			.share()
		
		presentedCategoryScreen
			.compactMap { $0.left }
			.bind {
				self.navigationController.popViewController(animated: true)
			}
			.disposed(by: disposeBag)
		
		Observable
			.merge(
				viewModel.output.storySelected,
				presentedCategoryScreen.compactMap { $0.right }
			)
			.withLatestFrom(appStore.stateObservable) { ($0, $1) }
			.flatMap { story, state -> Observable<Story> in
				if story.paid == 1 && !state.settingsState.subscriptionActive {
					return self.presentPurchaseModule(navigationController: self.navigationController, origin: .storyPlay)
						.filter { $0 }
						.map { _ in story }
				} else {
					return Observable.just(story)
				}
			}
			.flatMap { story in
				self.presentPlayerModule(navigationContoller: self.navigationController, story: story)
			}
			.subscribe()
			.disposed(by: disposeBag)
		
		return controller.navbarView.backButton.rx.tap.asObservable()
			.do(onNext: { [unowned navigationController] in
				navigationController.popViewController(animated: true)
			})
	}
	
	func presentPurchaseModule(
		navigationController: UINavigationController,
		origin: PurchaseScreenOrigin
	) -> Observable<Bool> {
		let coordinator = PurchaseModuleCoordinator(
			navigationController: navigationController,
			origin: origin
		)
		return coordinate(to: coordinator).map { result in
			return result == .purchasedOrRestored
		}
	}
	
	func presentCategoryScreen(
		navigationContoller: UINavigationController,
		category: Category
	) -> Observable<Either<Void, Story>> {
		let vm = CategoryControllerViewModel(
			category: category,
			state: appStore.stateObservable.map { $0.mainModuleState.discoverState }.distinctUntilChanged(),
			dispatch: MainModule.Action.discoverAction <*> App.Action.mainModuleAction <*> appStore.dispatch
		)
		
		let controller = CategoryViewController(viewModel: vm)

		navigationController.pushViewController(controller, animated: true)

		let result = Observable
			.merge(
				vm.output.backTap.map { Either<Void, Story>.left(value: Void()) },
				vm.output.selectedStory.map { value in Either<Void, Story>.right(value: value) }
			)

		return result
	}
	
	func presentPlayerModule(
		navigationContoller: UINavigationController,
		story: Story
	) -> Observable<Void> {
		let coordinator = PlayerModuleCoordinator(
			navigationController: navigationController,
			playerItem: story
		)
		
		return coordinate(to: coordinator)
	}

	
	func presentAuthorContent(navigationController: UINavigationController, author: Author) -> Observable<Void> {
		let authorModuleCoordinator = AuthorModuleCoordinator(
			author: author,
			navigationController: navigationController
		)
		return coordinate(to: authorModuleCoordinator)
	}
}

//
//  AuthorModuleCoordinator.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 12.11.2021.
//

import Foundation
import RxSwift
import UIKit
import RxUNILib
import UNILibCore

class AuthorModuleCoordinator: RxBaseCoordinator<Void> {
		
	let author: Author
	let navigationController: UINavigationController
	
	init(author: Author, navigationController: UINavigationController) {
		self.author = author
		self.navigationController = navigationController
	}
	
	override func start() -> Observable<Void> {
		
		let viewModel = AuthorViewControllerViewModel(
			author: author,
			state: appStore.stateObservable.map { $0.mainModuleState.discoverState }.distinctUntilChanged(),
			dispatch: MainModule.Action.discoverAction <*> App.Action.mainModuleAction <*> appStore.dispatch
		)
		
		let controller = AuthorViewController(viewModel: viewModel)
		
		let presentedStories = controller.authorAllStoriesButton.rx.tap
			.flatMapLatest { [unowned self] in
				self.presentStoriesScreen(
					navigationContoller: self.navigationController,
					target: .discoverStoriesForAutor(author: self.author)
				)
			}
			.share(replay: 1, scope: .whileConnected)
		
		presentedStories
			.subscribe(onNext: { [unowned self] v in
				if case .left = v {
					self.navigationController.popViewController(animated: true)
				}
			})
			.disposed(by: disposeBag)
				
		Observable
			.merge(
				presentedStories.compactMap { $0.right },
				viewModel.ouput.selectedStory
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
		
		navigationController.pushViewController(controller, animated: true)
		
		return controller.navbar.backButton.rx.tap.asObservable()
			.do(onNext: { [unowned navigationController] in
				navigationController.popViewController(animated: true)
		})
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
}

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
		
		navigationController.pushViewController(controller, animated: true)
		
		return controller.navbar.backButton.rx.tap.asObservable()
			.do(onNext: { [unowned navigationController] in
				navigationController.popViewController(animated: true)
		})
	}
}

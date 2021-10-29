//
//  CategoryModuleCoordinator.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 29.10.2021.
//

import Foundation
import UNILibCore
import RxUNILib
import UIKit
import RxSwift

class CatrgoryModuleCoordinator: RxBaseCoordinator<Void> {
	
	let navigationController: UINavigationController
	
	init(navigationController: UINavigationController) {
		self.navigationController = navigationController
	}
	
	override func start() -> Observable<Void> {
		
		let viewModel = CategoryViewModel()
		let controller = CategoryController(viewModel: viewModel)
		
		navigationController.pushViewController(controller, animated: true)
		
		return controller.navbarView.backButton.rx.tap.do(onNext: { [unowned navigationController] _ in
			navigationController.popViewController(animated: true)
		})
	}
}

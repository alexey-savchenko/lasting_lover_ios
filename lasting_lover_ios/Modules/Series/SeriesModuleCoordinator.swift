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
		
		return controller.navbarView.backButton.rx.tap.asObservable()
			.do(onNext: { [unowned navigationController] in
				navigationController.popViewController(animated: true)
			})
	}
}

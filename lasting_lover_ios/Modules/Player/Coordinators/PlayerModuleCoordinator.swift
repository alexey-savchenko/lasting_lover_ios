//
//  PlayerModuleCoordinator.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 14.10.2021.
//

import UIKit
import RxSwift
import RxUNILib
import UNILibCore

class PlayerModuleCoordinator: RxBaseCoordinator<Void> {
	
	let playerItem: PlayerItem
	let navigationController: UINavigationController
	
	lazy var store = RxStore(
		inputState: Player.State.default(item: playerItem),
		middleware: [Player.middleware],
		reducer: Player.reducer
	)
	
	init(navigationController: UINavigationController, playerItem: PlayerItem) {
		self.navigationController = navigationController
		self.playerItem = playerItem
	}
	
	override func start() -> Observable<Void> {
	
		store.attach(Player.Plugin.isPlayingPlugin)
		store.attach(Player.Plugin.playbackProgressPlugin)
		
		let viewModel = PlayerControllerViewModel(
			state: store.stateObservable,
			dispatch: store.dispatch
		)
		let controller = PlayerController(viewModel: viewModel)
		controller.modalPresentationStyle = .overFullScreen
		navigationController.present(controller, animated: true)
		
		let backTap = controller.navbar.backButton.rx.tap
			.do(onNext: { [weak controller, weak self] in
				self?.store.dispatch(.forcePausePlayback)
				controller?.dismiss(animated: true)
			})
			.asObservable()
				
				
		return backTap
	}
}

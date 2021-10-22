//
//  PlayerModuleCoordinator.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 14.10.2021.
//

import UIKit
import RxSwift
import RxUNILib

class PlayerModuleCoordinator: RxBaseCoordinator<Void> {

  let playerItem: PlayerItemProtocol
  let navigationController: UINavigationController
  
  init(navigationController: UINavigationController, playerItem: PlayerItemProtocol) {
    self.navigationController = navigationController
    self.playerItem = playerItem
  }
  
  override func start() -> Observable<Void> {
    
    let store = RxStore(
      inputState: Player.State.mock,
      middleware: [Player.middleware],
      reducer: Player.reducer
    )
    
    store.attach(Player.Plugin.isPlayingPlugin)
    store.attach(Player.Plugin.playbackProgressPlugin)
    
    let viewModel = PlayerControllerViewModel(
      state: store.stateObservable,
      dispatch: store.dispatch
    )
    let controller = PlayerController(viewModel: viewModel)

    navigationController.pushViewController(controller, animated: true)
    
    return .never()
  }
  
}

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
    
    let store = RxStore(inputState: Player.State.mock, middleware: [], reducer: Player.reducer)
    
//    let viewModel = PlayerControllerViewModel(
//      state: <#Observable<Player.State>#>,
//      dispatch: <#DispatchFunction<Player.Action>#>
//    )
//    let controller = PlayerController(viewModel: viewModel)
//
//    navigationController.pushViewController(controller, animated: true)
//
    return .never()
  }
  
}

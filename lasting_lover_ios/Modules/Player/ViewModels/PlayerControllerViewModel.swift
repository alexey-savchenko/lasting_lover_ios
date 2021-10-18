//
//  PlayerControllerViewModel.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 07.10.2021.
//

import Foundation
import RxSwift
import RxUNILib

class PlayerControllerViewModel {
  struct Input {  
    let playTap: AnyObserver<Void>
    let favoriteTap: AnyObserver<Void>
  }
  
  private let playTapSubject = PublishSubject<Void>()
  private let favoriteTapSubject = PublishSubject<Void>()
  
  struct Output {
    let title: Observable<String>
    let author: Observable<String>
    let isFavorite: Observable<Bool>
  }
  
  let input: Input
  let output: Output
  
  private let disposeBag = DisposeBag()
  
  init(
    state: Observable<Player.State>,
    dispatch: @escaping DispatchFunction<Player.Action>
  ) {
    self.input = Input(
      playTap: playTapSubject.asObserver(),
      favoriteTap: favoriteTapSubject.asObserver()
    )
    self.output = Output(
      title: state.map { $0.item.title }.distinctUntilChanged(),
      author: state.map { $0.item.author }.distinctUntilChanged(),
      isFavorite: state.map { $0.isFavourite }.distinctUntilChanged()
    )
    
    disposeBag.insert(
      playTapSubject.bind {
        dispatch(.playTap)
      },
      favoriteTapSubject.bind {
        dispatch(.favoriteTap)
      }
    )
  }
}

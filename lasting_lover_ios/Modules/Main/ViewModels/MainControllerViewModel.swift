//
//  MainControllerViewModel.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 03.10.2021.
//

import Foundation
import UNILibCore
import RxUNILib
import RxSwift

class MainControllerViewModel {
  
  struct Input {
    let selectedTabWithIndex: AnyObserver<Int>
  }
  
  let selectedTabWithIndexSubject = PublishSubject<Int>()
  
  struct Output {
    let selectedTabIndex: Observable<Int>
  }
  
  let input: Input
  let output: Output
  
  private let disposeBag = DisposeBag()
  
  init(
    state: Observable<AppState>,
    dispatch: @escaping DispatchFunction<AppAction>
  ) {
    self.input = Input(
      selectedTabWithIndex: selectedTabWithIndexSubject.asObserver()
    )
    self.output = Output(
      selectedTabIndex: state.map { $0.mainModuleState.selectedTabIndex }.distinctUntilChanged()
    )
    
    disposeBag
      .insert(
        selectedTabWithIndexSubject
          .subscribe(onNext: { value in dispatch(.mainModuleAction(action: .setTabIndex(value: value))) })
      )
  }
}

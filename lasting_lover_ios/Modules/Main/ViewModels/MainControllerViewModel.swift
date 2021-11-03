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
    let settingsButtonTap: AnyObserver<Void>
  }

  let selectedTabWithIndexSubject = PublishSubject<Int>()
  let settingsButtonTapSubject = PublishSubject<Void>()

  struct Output {
    let selectedTabIndex: Observable<Int>
    let settingsButtonTap: Observable<Void>
  }

  let input: Input
  let output: Output

  private let disposeBag = DisposeBag()

  init(
		state: Observable<MainModule.State>,
		dispatch: @escaping DispatchFunction<MainModule.Action>
  ) {
    self.input = Input(
      selectedTabWithIndex: selectedTabWithIndexSubject.asObserver(),
      settingsButtonTap: settingsButtonTapSubject.asObserver()
    )
    self.output = Output(
      selectedTabIndex: state.map { $0.selectedTabIndex }.distinctUntilChanged(),
      settingsButtonTap: settingsButtonTapSubject.asObservable()
    )

    disposeBag
      .insert(
        selectedTabWithIndexSubject
          .subscribe(onNext: { value in dispatch(.setTabIndex(value: value)) })
      )
  }
}

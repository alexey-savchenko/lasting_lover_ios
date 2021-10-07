//
//  PlayerControllerViewModel.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 07.10.2021.
//

import Foundation
import RxSwift

class PlayerControllerViewModel {
  struct Input {}

  struct Output {}

  let input: Input
  let output: Output

  private let disposeBag = DisposeBag()

  init() {
    self.input = Input()
    self.output = Output()
  }
}

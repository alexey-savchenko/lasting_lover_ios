//
//  DiscoverControllerViewModel.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 04.10.2021.
//

import Foundation
import RxSwift
import RxUNILib

class DiscoverControllerViewModel {
  struct Input {
    
  }
  
  struct Output {
    
  }
  
  let input: Input
  let output: Output
  
	init(state: Observable<Discover.State>, dispatch: @escaping DispatchFunction<Discover.Action>) {
    self.input = Input()
    self.output = Output()
  }
}

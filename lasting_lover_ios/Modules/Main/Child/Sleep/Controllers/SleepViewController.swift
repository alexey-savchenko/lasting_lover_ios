//
//  SleepViewController.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 03.10.2021.
//

import UIKit

class SleepViewController: ViewController<BackgroundImageView> {

  let viewModel: SleepControllerViewModel
  
  init(viewModel: SleepControllerViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  
  
}

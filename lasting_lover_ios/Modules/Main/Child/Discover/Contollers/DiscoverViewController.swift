//
//  DiscoverViewController.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 03.10.2021.
//

import UIKit

class DiscoverViewController: ViewController<BackgroundImageView> {

  let viewModel: DiscoverControllerViewModel
  
  init(viewModel: DiscoverControllerViewModel) {
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

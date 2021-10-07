//
//  PlayerController.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 07.10.2021.
//

import UIKit

class PlayerController: ViewController<BackgroundImageView> {
  let viewModel: PlayerControllerViewModel

  init(viewModel: PlayerControllerViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    setupUI()
    configure(with: viewModel)
  }

  private func setupUI() {}

  private func configure(with viewModel: PlayerControllerViewModel) {}
}

//
//  Snapshotable.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 07.10.2021.
//

import UIKit

protocol Snapshotable: UIView {
  static func make() -> Snapshotable
  func layoutIn(context: UIView)
}

extension Snapshotable {
  static func make() -> Snapshotable {
    return Self()
  }
}

class _SnapshotController<T: Snapshotable>: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
  
    view.backgroundColor = .darkGray
    
    let targetView = T.make()
    view.addSubview(targetView)
    targetView.layoutIn(context: view)
  }
}

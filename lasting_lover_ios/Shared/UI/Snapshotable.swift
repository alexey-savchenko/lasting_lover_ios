//
//  Snapshotable.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 07.10.2021.
//

import UIKit

protocol Snapshotable {
  static func make() -> Snapshotable
  func add(to context: UIViewController)
  func layoutIn(_ view: UIView)
}

protocol SnapshotableView: Snapshotable, UIView {
  
}

extension SnapshotableView {
  func add(to context: UIViewController) {
    context.view.addSubview(self)
  }
}

protocol SnapshotableController: Snapshotable, UIViewController {
  
}

extension SnapshotableController {
  func add(to context: UIViewController) {
    context.addChild(self)
    context.view.addSubview(self.view)
    self.didMove(toParent: context)
  }
  
  func layoutIn(_ view: UIView) {
    view.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }
}

class SnapshotController<Content: Snapshotable>: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
  
    view.backgroundColor = .darkGray
    
    let content = Content.make()
    content.add(to: self)
    content.layoutIn(view)
  }
}

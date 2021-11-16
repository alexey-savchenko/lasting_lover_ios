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

extension Snapshotable where Self: UIView {
  func add(to context: UIViewController) {
    context.view.addSubview(self)
  }
  
  static func make() -> Snapshotable {
    return Self()
  }
}

extension Snapshotable where Self: UIViewController {
  func add(to context: UIViewController) {
    context.addChild(self)
    context.view.addSubview(self.view)
    self.didMove(toParent: context)
  }

  func layoutIn(_ view: UIView) {
		self.view.frame = view.bounds
  }
}

class SnapshotController<Content: Snapshotable>: UIViewController {
  
  let content = Content.make()
  
  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .darkGray
    content.add(to: self)
    content.layoutIn(view)
  }
}

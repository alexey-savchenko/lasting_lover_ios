//
//  Insetlabel.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 06.10.2021.
//

import UIKit

class InsetLabel: UILabel {
  init(inset: UIEdgeInsets = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)) {
    self.inset = inset
    super.init(frame: .zero)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  let inset: UIEdgeInsets

  override func drawText(in rect: CGRect) {
    super.drawText(in: rect.inset(by: inset))
  }

  override var intrinsicContentSize: CGSize {
    var intrinsicContentSize = super.intrinsicContentSize
    intrinsicContentSize.width += inset.left + inset.right
    intrinsicContentSize.height += inset.top + inset.bottom
    return intrinsicContentSize
  }
}

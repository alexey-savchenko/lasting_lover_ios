//
//  BackgroundGradientView.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 30.09.2021.
//

import UIKit

class BackgroundGradientView: UIView {

  let gradientLayer = CAGradientLayer()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    layer.addSublayer(gradientLayer)
    gradientLayer.colors = [
      Asset.Colors.backgroundGradientTop.color.cgColor,
      Asset.Colors.backgroundGradientBottom.color.cgColor
    ]

    gradientLayer.locations = [0, 1]
    gradientLayer.startPoint = CGPoint(x: 0.25, y: 0.5)
    gradientLayer.endPoint = CGPoint(x: 0.75, y: 0.5)
//    gradientLayer.transform = CATransform3DMakeAffineTransform(CGAffineTransform(a: -0.37, b: -0.87, c: -0.87, d: 0.37, tx: 0.89, ty: 0.22))
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
//    gradientLayer.frame =
    let f = layer.bounds.insetBy(dx: -bounds.width * 0.5, dy: -bounds.height * 0.5)
    gradientLayer.frame = f
    gradientLayer.transform = CATransform3DMakeAffineTransform(CGAffineTransform(rotationAngle: 45 * CGFloat.pi / 180).concatenating(.init(scaleX: 2, y: 2)))
  }
}

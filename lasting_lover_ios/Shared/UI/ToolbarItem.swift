//
//  ToolBarItem.swift
//  App
//
//  Created by Vadym Yakovlev on 27.02.2020.
//  Copyright © 2020 Vadym Yakovlev. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import UNILibCore
import RxUNILib

protocol ToolbarItemProtocol: UIView {
  var tap: Observable<Void> { get }
  func setSelected(_ isSelected: Bool)
  func setEnabled(_ isEnabled: Bool)
}

extension ToolbarItemProtocol {
  func setEnabled(_ isEnabled: Bool) {
    if isEnabled {
      alpha = 1
      isUserInteractionEnabled = true
    } else {
      alpha = 0.5
      isUserInteractionEnabled = false
    }
  }
}

extension Reactive where Base: ToolbarItemProtocol {
  var isSelected: Binder<Bool> {
    return Binder<Bool>(self.base, binding: { view, isSelected in
      view.setSelected(isSelected)
    })
  }
  
  var isEnabled: Binder<Bool> {
    return Binder<Bool>(self.base, binding: { view, isEnabled in
      view.setEnabled(isEnabled)
    })
  }
}

class _ToolBarItem: UIView, ToolbarItemProtocol {

  init(
    image: UIImage,
    text: String,
    selectedColors: (UIColor, UIColor),
    deselectedColors: (UIColor, UIColor)
  ) {
    self.image = image
    self.text = text
    self.selectedColors = selectedColors
    self.deselectedColors = deselectedColors

    super.init(frame: .zero)
    
    addGestureRecognizer(tapGesture)
    isUserInteractionEnabled = true
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  let image: UIImage
  let text: String
  
  let selectedColors: (UIColor, UIColor)
  let deselectedColors: (UIColor, UIColor)
  
  var isSelected: Bool = false
  private let tapGesture = UITapGestureRecognizer(target: nil, action: nil)
  var tap: Observable<Void> {
    return tapGesture.rx.event.map(toVoid)
  }
  
  func setSelected(_ isSelected: Bool) {
    self.isSelected = isSelected
    setNeedsLayout()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    let colors = isSelected ? selectedColors : deselectedColors
    
    let s = toolbarImage(image: image, text: text, color0: colors.0, color1: colors.1, rect: bounds)
    layer.contents = s.cgImage
  }
}

func toolbarImage(image: UIImage, text: String, color0: UIColor, color1: UIColor, rect: CGRect) -> UIImage {

  let format = UIGraphicsImageRendererFormat()
  format.scale = UIScreen.main.scale
  let renderer = UIGraphicsImageRenderer(bounds: rect, format: format)
  
  let mask = renderer.image { ctx in
    ctx.cgContext.translateBy(x: 0, y: rect.height)
    ctx.cgContext.scaleBy(x: 1, y: -1)
    let string = NSAttributedString(
      string: text,
      attributes: [.font: FontFamily.Nunito.regular.font(size: 12)]
    )
    let stringSize = string.size()
    let imageSize = CGSize(width: 24, height: 24)
    
    let imageRect = CGRect(
      x: rect.middle.x - imageSize.width / 2,
      y: 0,
      width: imageSize.width,
      height: imageSize.height
    )
    image.draw(in: imageRect)
    
    let stringRect = CGRect(
      x: rect.middle.x - stringSize.width / 2,
      y: rect.maxY - stringSize.height,
      width: stringSize.width,
      height: stringSize.height
    )
    string.draw(in: stringRect)
  }
  
  let gradient = horizontalGradientImage(size: rect.size, color0: color0, color1: color1)
  
//  let colors = [color0.cgColor, color1.cgColor]
//  let colorSpace = CGColorSpaceCreateDeviceRGB()
//  let colorLocations: [CGFloat] = [0.0, 1.0]
//  let gradient = CGGradient(
//    colorsSpace: colorSpace,
//    colors: colors as CFArray,
//    locations: colorLocations
//  )!
//
//  let startPoint = CGPoint.zero
//  let endPoint = CGPoint(x: rect.width, y: 0)
//
  let result = renderer.image { ctx in
    ctx.cgContext.clip(to: rect, mask: mask.cgImage!)
    gradient.draw(in: rect)
//    ctx.cgContext.drawLinearGradient(
//      gradient,
//      start: startPoint,
//      end: endPoint,
//      options: []
//    )
  }
  
  return result
}

func horizontalGradientImage(
  size: CGSize,
  color0: UIColor,
  color1: UIColor
) -> UIImage {
  let rect = CGRect(origin: .zero, size: size)
  let format = UIGraphicsImageRendererFormat()
  format.scale = UIScreen.main.scale
  let renderer = UIGraphicsImageRenderer(bounds: rect, format: format)
  let colors = [color0.cgColor, color1.cgColor]
  let colorSpace = CGColorSpaceCreateDeviceRGB()
  let colorLocations: [CGFloat] = [0.0, 1.0]
  let gradient = CGGradient(
    colorsSpace: colorSpace,
    colors: colors as CFArray,
    locations: colorLocations
  )!
  
  let startPoint = CGPoint.zero
  let endPoint = CGPoint(x: rect.width, y: 0)
  
  let result = renderer.image { ctx in
    ctx.cgContext.drawLinearGradient(
      gradient,
      start: startPoint,
      end: endPoint,
      options: []
    )
  }
  return result
}

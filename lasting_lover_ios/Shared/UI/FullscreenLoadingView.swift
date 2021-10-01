//
//  FullscreenLoadingView.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 01.10.2021.
//

import UIKit

class FullscreenLoadingView: UIView {
  
  let activityIndicator = UIActivityIndicatorView(style: .medium)
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    backgroundColor = Asset.Colors.grayTransparent.color
    addSubview(activityIndicator)
    activityIndicator.snp.makeConstraints { make in
      make.center.equalToSuperview()
    }
    activityIndicator.startAnimating()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

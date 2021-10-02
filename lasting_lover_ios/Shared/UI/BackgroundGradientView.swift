//
//  BackgroundGradientView.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 30.09.2021.
//

import UIKit

class BackgroundImageView: UIImageView {
	override init(frame: CGRect) {
		super.init(frame: frame)
		image = Asset.Images.background.image
		contentMode = .scaleAspectFill
	}
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

class BackgroundFlareImageView: BackgroundImageView {
  
  let flareImageView = UIImageView(image: Asset.Images.backgroundFlareImage.image)
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    addSubview(flareImageView)
    flareImageView.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.leading.equalToSuperview().offset(36)
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

class ViewController<BackgroundView: UIImageView>: UIViewController {
  let backgroundView = BackgroundView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.addSubview(backgroundView)
    backgroundView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }
}

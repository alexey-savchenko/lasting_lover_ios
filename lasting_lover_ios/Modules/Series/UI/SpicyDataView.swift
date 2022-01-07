//
//  SeriesProgressBar.swift
//  lasting_lover_ios
//
//  Created by Oleksii Savchenko on 07.01.2022.
//

import UIKit

class SpicyDataView: UIView {
  
  class SpicyMarkView: UIView {
    
    let stackView = UIStackView()
    let label = UILabel()
    let imageView = UIImageView(image: Asset.Images.fxemojiFire.image)
    
    override init(frame: CGRect) {
      super.init(frame: frame)
      
      addSubview(stackView)
      stackView.snp.makeConstraints { make in
        make.leading.trailing.equalToSuperview().inset(6)
        make.centerY.equalToSuperview()
      }
      [label, imageView].forEach(stackView.addArrangedSubview)
      
      stackView.axis = .horizontal
      stackView.spacing = 2
      layer.cornerRadius = 10
      clipsToBounds = true
      backgroundColor = UIColor(red: 32.0 / 255.0, green: 14.0 / 255.0, blue: 42.0 / 255.0, alpha: 0.8)
      label.textColor = .white
      label.font = FontFamily.Nunito.semiBold.font(size: 12)
      label.textAlignment = .center
      imageView.contentMode = .scaleAspectFit
      imageView.snp.makeConstraints { make in
        make.size.equalTo(16)
      }
    }
    
    required init(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
  }
  
  class ProgressBar: UIView {
    
    let progressLayer = CAShapeLayer()
    
    var progressValue: Double = 0 {
      didSet {
//        setNeedsLayout()
        progressLayer.strokeEnd = progressValue
      }
    }
    
    override init(frame: CGRect) {
      super.init(frame: frame)
      
      setupUI()
    }
    
    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
      clipsToBounds = true
      backgroundColor = UIColor(
        red: 32.0 / 255.0, green: 14.0 / 255.0, blue: 42.0 / 255.0, alpha: 0.8)
      layer.addSublayer(progressLayer)
      progressLayer.fillColor = UIColor(
        red: 32.0 / 255.0, green: 14.0 / 255.0, blue: 42.0 / 255.0, alpha: 0.8).cgColor
      progressLayer.strokeColor = UIColor(hexString: "4831A9").cgColor
      progressLayer.lineWidth = 10
      progressLayer.lineCap = .round
      progressLayer.strokeEnd = 0
    }
    
    override func layoutSubviews() {
      super.layoutSubviews()
      
      layer.cornerRadius = bounds.height / 2
      progressLayer.frame = bounds
      let path = CGMutablePath()
      path.move(to: CGPoint.init(x: 0, y: bounds.height / 2))
      path.addLine(to: CGPoint.init(x: bounds.width, y: bounds.height / 2))
      progressLayer.path = path
    }
  }

  let markView = SpicyMarkView()
  let progressBarView = ProgressBar()
  var progress: Double = 0
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    [markView, progressBarView].forEach(addSubview)
    progressBarView.snp.makeConstraints { make in
      make.leading.trailing.bottom.equalToSuperview()
      make.height.equalTo(10)
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setSpicyData(value: (Double, String)) {
    self.progress = value.0
    self.progressBarView.progressValue = value.0
    self.markView.label.text = value.1

//    layoutIfNeeded()
    setNeedsLayout()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    let s = NSAttributedString(
      string: markView.label.text ?? "",
      attributes: [.font: FontFamily.Nunito.semiBold.font(size: 12)]
    )
    
    let width = s.size().width + 40
    
    markView.frame = CGRect(x: bounds.width * progress - width / 2, y: 0, width: width, height: 24)
  }
}

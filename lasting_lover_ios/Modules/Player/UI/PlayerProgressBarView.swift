//
//  PlayerProgressBarView.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 18.10.2021.
//

import UIKit
import RxSwift

class PlayerProgressBarView: UIView {

  let containerView = UIView()
  let progressFillView = UIView()
  
  let indicatorView: UIView = {
    let bgImageView = UIView()
    let indicatorImageView = UIImageView(image: Asset.Images.playerProgressBarIndicatorImage.image)
    bgImageView.addSubview(indicatorImageView)
    indicatorImageView.snp.makeConstraints { make in
      make.center.equalToSuperview()
    }
    bgImageView.snp.makeConstraints { make in
      make.size.equalTo(18)
    }
    bgImageView.clipsToBounds = true
    bgImageView.layer.cornerRadius = 9
    bgImageView.backgroundColor = UIColor(hexString: "ADB9D1").withAlphaComponent(0.35)
    return bgImageView
  }()
  
  let panGesture = UIPanGestureRecognizer(target: nil, action: nil)
  private let disposeBag = DisposeBag()
  
  private let seekToProgressSubject = PublishSubject<Double>()
  var seekToProgress: Observable<Double> {
    return seekToProgressSubject.asObservable()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setupUI() {
    [containerView, indicatorView].forEach {
      addSubview($0)
      $0.isUserInteractionEnabled = false
    }
    containerView.backgroundColor = UIColor(hexString: "47557E").withAlphaComponent(0.5)
    containerView.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.height.equalTo(3)
      make.leading.trailing.equalToSuperview()
    }
    containerView.addSubview(progressFillView)
    containerView.clipsToBounds = true
    containerView.layer.cornerRadius = 1.5
    progressFillView.backgroundColor = UIColor(hexString: "4A80F0")
    progressFillView.snp.makeConstraints { make in
      make.leading.top.bottom.equalToSuperview()
      make.width.equalToSuperview().multipliedBy(0)
    }
    
    indicatorView.snp.makeConstraints { make in
      make.centerX.equalTo(progressFillView.snp.trailing)
      make.centerY.equalTo(progressFillView)
    }
    
    addGestureRecognizer(panGesture)
    panGesture.rx.event
      .map { [unowned self] gesture in
        return (Double((gesture.location(in: self).x / self.bounds.width).clamped(min: 0, max: 1)), gesture.state)
      }
      .bind { [unowned self] value, gestureState in
        self._setProgress(value)
        if gestureState == .ended {
          seekToProgressSubject.onNext(value)
        }
      }
      .disposed(by: disposeBag)
  }
  
  private func _setProgress(_ value: Double) {
		guard value != .nan || value != .signalingNaN else { return }
    progressFillView.snp.remakeConstraints { make in
      make.leading.top.bottom.equalToSuperview()
      make.width.equalToSuperview().multipliedBy(value)
    }
  }
  
  func setProgress(_ value: Double) {
    if panGesture.state == .possible {
      _setProgress(value)
    }
  }
}

extension PlayerProgressBarView: Snapshotable {
  func layoutIn(_ view: UIView) {
    snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview().inset(16)
      make.height.equalTo(32)
      make.centerY.equalToSuperview()
    }
  }
}

//
//  UIPresentationController+Rx.swift
//  App
//
//  Created by Artur Maiorskyi on 11.09.2020.
//  Copyright © 2020 Vadym Yakovlev. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UIPresentationController {
  public var presentationControllerDidDismiss: Observable<UIPresentationController> {
    RxPresentationControllerDelegateProxy.proxy(for: base)
      .presentationControllerDidDismiss
      .asObservable()
  }
}

class RxPresentationControllerDelegateProxy: DelegateProxy<UIPresentationController, UIAdaptivePresentationControllerDelegate>,
  DelegateProxyType,
  UIAdaptivePresentationControllerDelegate {
  
  init(presentationController: UIPresentationController) {
    super.init(
      parentObject: presentationController,
      delegateProxy: RxPresentationControllerDelegateProxy.self
    )
  }

  // MARK: DelegateProxyType
  static func registerKnownImplementations() {
    self.register { RxPresentationControllerDelegateProxy(presentationController: $0) }
  }

  static func currentDelegate(
    for object: UIPresentationController
  ) -> UIAdaptivePresentationControllerDelegate? {
    object.delegate
  }

  static func setCurrentDelegate(
    _ delegate: UIAdaptivePresentationControllerDelegate?,
    to object: UIPresentationController
  ) {
    object.delegate = delegate
  }

  // MARK: ProxySubject
  lazy var presentationControllerDidDismiss = PublishSubject<UIPresentationController>()

  func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
    presentationControllerDidDismiss.onNext(presentationController)
  }

  // MARK: Completed
  deinit {
    presentationControllerDidDismiss.onCompleted()
  }
}

//
//  PurchaseScreenViewProtocol.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 26.11.2021.
//

import UIKit
import RxSwift

protocol PurchaseScreenViewProtocol: UIView {
	var selectedIAP: AnyObserver<IAP> { get }
	var selectedIAPTap: Observable<IAP> { get }
	var purchaseTap: Observable<Void> { get }
	var restoreTap: Observable<Void> { get }
	var dismissTap: Observable<Void> { get }
	var policyTap: Observable<Policy> { get }
}

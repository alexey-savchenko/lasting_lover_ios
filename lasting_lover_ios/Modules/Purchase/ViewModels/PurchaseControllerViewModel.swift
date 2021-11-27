//
//  PurchaseControllerViewModel.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 25.11.2021.
//

import Foundation
import RxSwift
import RxUNILib


class PurchaseControllerViewModel {
	struct Input {
		let dismissTap: AnyObserver<Void>
		let selectedIAP: AnyObserver<IAP>
		let purchaseTap: AnyObserver<Void>
		let restoreTap: AnyObserver<Void>
		let policyTap: AnyObserver<Policy>
	}
	
	private let dismissTapSubject = PublishSubject<Void>()
	private let purchaseTapSubject = PublishSubject<Void>()
	private let restoreTapSubject = PublishSubject<Void>()
	private let selectedIAPSubject = PublishSubject<IAP>()
	private let policyTapSubject = PublishSubject<Policy>()
	
	struct Output {
		let dismissTap: Observable<Void>
		let origin: Observable<PurchaseScreenOrigin>
		let isLoading: Observable<Bool>
		let policyTap: Observable<Policy>
		let error: Observable<LocalizedError>
	}
	
	let input: Input
	let output: Output
	
	private let disposeBag = DisposeBag()
	
	init(
		state: Observable<PurchaseModule.State>,
		dispatch: @escaping DispatchFunction<PurchaseModule.Action>
	) {
		self.input = Input(
			dismissTap: dismissTapSubject.asObserver(),
			selectedIAP: selectedIAPSubject.asObserver(),
			purchaseTap: purchaseTapSubject.asObserver(),
			restoreTap: restoreTapSubject.asObserver(),
			policyTap: policyTapSubject.asObserver()
		)
		self.output = Output(
			dismissTap: dismissTapSubject.asObservable(),
			origin: state.map { $0.origin }.distinctUntilChanged(),
			isLoading: state.map { $0.isLoading }.distinctUntilChanged(),
			policyTap: policyTapSubject.asObservable(),
			error: state.map { $0.error }.filterNil().distinctUntilChanged().map { $0.value } 
		)
		
		disposeBag.insert(
			dismissTapSubject.bind { dispatch(.dismissTap) },
			selectedIAPSubject.bind { value in dispatch(.selectedIAP(value: value)) },
			purchaseTapSubject.bind { dispatch(.purchase) },
			restoreTapSubject.bind { dispatch(.restore) }
		)
	}
}

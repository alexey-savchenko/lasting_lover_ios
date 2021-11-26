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
	}
	
	private let dismissTapSubject = PublishSubject<Void>()
	private let purchaseTapSubject = PublishSubject<Void>()
	private let restoreTapSubject = PublishSubject<Void>()
	private let selectedIAPSubject = PublishSubject<IAP>()
	
	struct Output {
		let dismissTap: Observable<Void>
		let origin: Observable<PurchaseScreenOrigin>
		let isLoading: Observable<Bool>
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
			restoreTap: restoreTapSubject.asObserver()
		)
		self.output = Output(
			dismissTap: dismissTapSubject.asObservable(),
			origin: state.map { $0.origin }.distinctUntilChanged(),
			isLoading: state.map { $0.isLoading }.distinctUntilChanged()
		)
		
		disposeBag.insert(
			dismissTapSubject.bind { dispatch(.dismissTap) },
			selectedIAPSubject.bind { value in dispatch(.selectedIAP(value: value)) },
			purchaseTapSubject.bind { dispatch(.purchase) },
			restoreTapSubject.bind { dispatch(.restore) }
		)
	}
}

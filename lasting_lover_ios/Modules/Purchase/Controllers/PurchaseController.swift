//
//  PurchaseControllerController.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 25.11.2021.
//

import UIKit
import RxSwift

class PurchaseController: UIViewController {
	
	let viewModel: PurchaseControllerViewModel
	private let disposeBag = DisposeBag()
	
	let loadingView = FullscreenLoadingView()
	
	init(viewModel: PurchaseControllerViewModel) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	var _view: PurchaseScreenViewProtocol?
	
//	override func loadView() {
//
//	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupUI()
		configure(with: viewModel)
	}
	
	fileprivate func setupLoadingView() {
		loadingView.snp.makeConstraints { make in
			make.edges.equalToSuperview()
		}
	}
	
	private func setupUI() {
		view.addSubview(loadingView)
		
		setupLoadingView()
	}
	
	private func configure(with viewModel: PurchaseControllerViewModel) {
		viewModel.output.origin
			.bind { [unowned self] value in
				let view = Current.purchaseScreenFactory().make(from: value)
				self.view.addSubview(view)
				self._view = view
				self.view.sendSubviewToBack(view)
				view.snp.makeConstraints { make in
					make.edges.equalToSuperview()
				}
				
				view.dismissTap
					.subscribe(viewModel.input.dismissTap)
					.disposed(by: self.disposeBag)
				view.purchaseTap
					.subscribe(viewModel.input.purchaseTap)
					.disposed(by: self.disposeBag)
				view.restoreTap
					.subscribe(viewModel.input.restoreTap)
					.disposed(by: self.disposeBag)
				view.selectedIAPTap
					.subscribe(viewModel.input.selectedIAP)
					.disposed(by: self.disposeBag)
				view.policyTap
					.subscribe(viewModel.input.policyTap)
					.disposed(by: self.disposeBag)
			}
			.disposed(by: disposeBag)

		viewModel.output.isLoading
			.bind { [weak self] value in
				self?.loadingView.isHidden = !value
			}
			.disposed(by: disposeBag)
		viewModel.output.error
			.bind { [weak self] error in
				self?.presentError(error)
			}
			.disposed(by: disposeBag)
	}
}

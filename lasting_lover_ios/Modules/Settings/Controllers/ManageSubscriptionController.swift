//
//  ManageSubscriptionController.swift.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 16.11.2021.
//

import UIKit

class SubscriptionManagementController: SettingsScreen {
	
	enum ButtonConfig {
		case hidden
		case shown(title: String)
	}
	
	let subtitleLabel = UILabel()
	let buttonsStackView = UIStackView()
	let button1 = Button(style: .primary, title: L10n.settingsSubscribe)
	let button2 = Button(style: .secondary, title: L10n.settingsRestorePurchase)
	
	let viewModel: SubscriptionManagementControllerViewModel
	
	
	init(viewModel: SubscriptionManagementControllerViewModel) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		configure(with: viewModel)
	}
	
	override func setupUI() {
		super.setupUI()
		
		titleLabel.text = L10n.settingsManageSubscription
		subtitleLabel.text = L10n.settingsManageSubscriptionUnsubsribedSubtitle
		
		[subtitleLabel, buttonsStackView].forEach(view.addSubview)
		subtitleLabel.textColor = .white.withAlphaComponent(0.5)
		subtitleLabel.font = FontFamily.Nunito.regular.font(size: 15)
		subtitleLabel.numberOfLines = 0
		subtitleLabel.snp.makeConstraints { make in
			make.top.equalTo(titleLabel.snp.bottom).offset(8)
			make.leading.trailing.equalToSuperview().inset(24)
		}
		
		buttonsStackView.snp.makeConstraints { make in
			make.leading.trailing.equalToSuperview().inset(24)
			make.top.equalTo(subtitleLabel.snp.bottom).offset(16)
		}
		buttonsStackView.axis = .vertical
		buttonsStackView.spacing = 16
		[button1, button2].forEach { b in
			b.snp.makeConstraints { make in
				make.height.equalTo(56)
			}
			buttonsStackView.addArrangedSubview(b)
		}
	}
	
	private func apply(_ cfg: ButtonConfig, to button: Button) {
		switch cfg {
		case .shown(let title):
			button.isHidden = false
			button.title = title
		case .hidden:
			button.isHidden = true
		}
	}
	
	private func configure(with viewModel: SubscriptionManagementControllerViewModel) {
		navbarView.backButton.rx.tap.bind { [unowned self] in
			self.navigationController?.popViewController(animated: true)
		}
		.disposed(by: disposeBag)
		viewModel.output.subtitle
			.map(Optional.init)
			.subscribe(subtitleLabel.rx.text)
			.disposed(by: disposeBag)
		viewModel.output.button1Config
			.bind { [unowned self] value in
				self.apply(value, to: self.button1)
			}
			.disposed(by: disposeBag)
		viewModel.output.button2Config
			.bind { [unowned self] value in
				self.apply(value, to: self.button2)
			}
			.disposed(by: disposeBag)
	}
}

extension SubscriptionManagementController: Snapshotable {
	static func make() -> Snapshotable {
		let vm = SubscriptionManagementControllerViewModel(
			state: .just(
				Settings.State(
					subscriptionActive: true,
					items: SettingsItem.allCases,
					notificationsEnabled: false
				)
			),
			dispatch: { _ in }
		)
		let c = SubscriptionManagementController(viewModel: vm)
		return c
	}
}

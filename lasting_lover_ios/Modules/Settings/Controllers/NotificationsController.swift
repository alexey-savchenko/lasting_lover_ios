//
//  NotificationsController.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 16.11.2021.
//

import UIKit
import RxSwift
import RxCocoa
import UNILibCore

class NotificationsController: SettingsScreen {
	
	let labelsStackView = UIStackView()
	let smallTitleLabel = UILabel()
	let subtitleLabel = UILabel()
	let hiddenButton = UIButton()
	let `switch` = UISwitch()
	
	let viewModel: NotificationsControllerViewModel
	
	init(viewModel: NotificationsControllerViewModel) {
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
		
		[labelsStackView, `switch`, hiddenButton].forEach(view.addSubview)
		
		labelsStackView.distribution = .fill
		labelsStackView.axis = .vertical
		labelsStackView.spacing = 16
		
		labelsStackView.snp.makeConstraints { make in
			make.leading.equalToSuperview().offset(24)
			make.top.equalTo(titleLabel.snp.bottom).offset(8)
			make.trailing.equalTo(`switch`.snp.leading).offset(-16)
		}
		
		[smallTitleLabel, subtitleLabel].forEach(labelsStackView.addArrangedSubview)
		smallTitleLabel.text = L10n.settingsNotificationsGeneralNotification
		smallTitleLabel.textColor = .white
		smallTitleLabel.font = FontFamily.Nunito.semiBold.font(size: 17)
		
		subtitleLabel.numberOfLines = 0
		subtitleLabel.textColor = .white.withAlphaComponent(0.5)
		subtitleLabel.font = FontFamily.Nunito.regular.font(size: 15)
		
		`switch`.isUserInteractionEnabled = false
		`switch`.snp.makeConstraints { make in
			make.trailing.equalToSuperview().offset(-24)
			make.centerY.equalTo(smallTitleLabel)
		}
		
		hiddenButton.snp.makeConstraints { make in
			make.edges.equalTo(`switch`)
		}
	}
	
	private func configure(with viewModel: NotificationsControllerViewModel) {
		viewModel.output.subtitle
			.map(Optional.init)
			.subscribe(subtitleLabel.rx.text)
			.disposed(by: disposeBag)
		viewModel.output.switchIsOn
			.subscribe(`switch`.rx.isOn)
			.disposed(by: disposeBag)
		hiddenButton.rx.tap
			.subscribe(viewModel.input.switchTap)
			.disposed(by: disposeBag)
		navbarView.backButton.rx.tap
			.bind { [unowned self] in
				self.navigationController?.popViewController(animated: true)
			}
			.disposed(by: disposeBag)
	}
}

extension NotificationsController: Snapshotable {
	static func make() -> Snapshotable {
		let vm = NotificationsControllerViewModel(
			state: .just(Settings.State(
				subscriptionActive: false,
				items: [],
				notificationsEnabled: false,
				isLoading: false,
				errors: nil
			)),
			dispatch: { _ in  }
		)
		let c = NotificationsController(viewModel: vm)
		return c
	}
}

//
//  VerticalScrollingView.swift
//  call_recorder
//
//  Created by Alexey Savchenko on 12.08.2020.
//  Copyright © 2020 Universe. All rights reserved.
//

import UIKit

class VerticalScrollingView: UIView {
	// MARK: - UI

	let scrollView = UIScrollView()
	let containerView = UIView()

	// MARK: - Init and deinit

	override init(frame: CGRect) {
		super.init(frame: frame)
		setupUI()
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	deinit {
		print("\(self) dealloc")
	}

	// MARK: - Functions

	func setupUI() {
		scrollView.contentInsetAdjustmentBehavior = .never

		addSubview(scrollView)
		scrollView.snp.makeConstraints { make in
			make.edges.equalToSuperview()
		}

		scrollView.showsHorizontalScrollIndicator = false
		scrollView.showsVerticalScrollIndicator = false
		scrollView.addSubview(containerView)
		containerView.snp.makeConstraints { make in
			make.edges.equalToSuperview()
			make.width.equalToSuperview()
			make.height.equalToSuperview().priority(250)
		}
		containerView.backgroundColor = .clear
	}
}

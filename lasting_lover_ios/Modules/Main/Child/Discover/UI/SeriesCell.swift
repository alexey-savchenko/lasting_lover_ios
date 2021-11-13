//
//  SeriesCell.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 13.11.2021.
//

import UIKit
import RxSwift

class SeriesCell: UICollectionViewCell {
	private var disposeBag = DisposeBag()
	weak var viewModel: AllSeriesCellViewModel?
	
	let imageView = UIImageView()
	let titleLabel = UILabel()
	let subtitleLabel = UILabel()
	let episodeCountLabel = UILabel()
	let durationLabel = UILabel()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		setupUI()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setupUI() {
		[imageView, titleLabel, subtitleLabel, episodeCountLabel, durationLabel]
			.forEach(contentView.addSubview)
		
		imageView.contentMode = .scaleAspectFit
		imageView.snp.makeConstraints { make in
			make.leading.equalToSuperview().offset(24)
			make.top.bottom.equalToSuperview()
			make.width.equalTo(imageView.snp.height)
		}
		
		titleLabel.font = FontFamily.Nunito.semiBold.font(size: 22)
		titleLabel.textColor = .white
		titleLabel.snp.makeConstraints { make in
			make.top.equalToSuperview().offset(8)
			make.leading.equalTo(imageView.snp.trailing).offset(24)
			make.trailing.equalToSuperview()
		}
		
		subtitleLabel.numberOfLines = 4
		subtitleLabel.font = FontFamily.Nunito.regular.font(size: 12)
		subtitleLabel.textColor = .white.withAlphaComponent(0.8)
		subtitleLabel.snp.makeConstraints { make in
			make.top.equalTo(titleLabel.snp.bottom).offset(12)
			make.leading.equalTo(imageView.snp.trailing).offset(24)
			make.trailing.equalToSuperview()
		}

		subtitleLabel.font = FontFamily.Nunito.regular.font(size: 12)
		subtitleLabel.textColor = .white.withAlphaComponent(0.5)
		episodeCountLabel.snp.makeConstraints { make in
			make.top.equalTo(subtitleLabel.snp.bottom).offset(10)
			make.leading.equalTo(imageView.snp.trailing).offset(24)
			make.trailing.equalToSuperview()
		}
	}
	
	func configure(with viewModel: AllSeriesCellViewModel) {
		self.viewModel = viewModel
		viewModel.output.image
			.map(Optional.init)
			.subscribe(imageView.rx.image)
			.disposed(by: disposeBag)
		titleLabel.text = viewModel.output.title
		subtitleLabel.text = viewModel.output.subtitle
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()
		
		disposeBag = DisposeBag()
	}
}

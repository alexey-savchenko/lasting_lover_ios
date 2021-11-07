//
//  SeriesCellViewMode.swift.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 05.11.2021.
//

import Foundation
import RxSwift
import UIKit

class SeriesCellViewModel: RoundedRectAndTitleSubtitleCellViewModelProtocol {
	var image: Observable<UIImage> {
		return Current.imageLoadingService().image(URL(string: series.avatar)!)
	}
	
	var title: String {
		return series.name
	}
	
	var subtitle: String {
		return series.description
	}
	
	var shouldDisplayPlayImage: Bool {
		return true
	}
	
	var accessoryViewMode: CardCell.AccessoryViewMode {
		return .hide
	}
	
	var shouldDisplayCherryView: Bool {
		return true
	}
	
	init(series: Series) {
		self.series = series
	}
	
	let series: Series
}

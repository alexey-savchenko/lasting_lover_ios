//
//  StoriesLayout.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 07.11.2021.
//

import Foundation
import UIKit

class StoriesLayout: UICollectionViewFlowLayout {
	
	override func prepare() {
		super.prepare()
		
		guard collectionView != nil else { return }
		
		setup()
	}
	
	private func setup() {
		let inset: CGFloat = 24
		scrollDirection = .horizontal
		minimumLineSpacing = 16
		let itemWidth = collectionView!.bounds.width - inset * 2 - minimumLineSpacing
		let itemHeight = collectionView!.bounds.height
		itemSize = CGSize(width: itemWidth, height: itemHeight)
		collectionView!.contentInset = .init(top: 0, left: inset, bottom: 0, right: inset)
	}
	
	override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
		return true
	}
}

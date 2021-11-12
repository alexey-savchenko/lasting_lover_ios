//
//  Serieslayout.swift.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 05.11.2021.
//

import Foundation
import UIKit

class SeriesLayout: UICollectionViewFlowLayout {
	
	override func prepare() {
		super.prepare()
		
		guard collectionView != nil else { return }
		
		setup()
	}
	
	private func setup() {
		let inset: CGFloat = 24
		scrollDirection = .vertical
		minimumLineSpacing = 16
		minimumInteritemSpacing = 16
//		16
		
		let itemWidth = collectionView!.bounds.width / 2 - minimumLineSpacing * 2
//		- inset / 2 - minimumLineSpacing * 2
		let itemHeight = 244.0
//		collectionView!.bounds.height - 60
		itemSize = CGSize(width: itemWidth, height: itemHeight)
		collectionView!.contentInset = .init(top: 24, left: inset, bottom: 24, right: inset)
	}
	
	override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
		return true
	}
	override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
		guard let allAttributes = super.layoutAttributesForElements(in: rect) else { return nil }
		
		for attributes in allAttributes {
			if attributes.indexPath.item % 2 == 0 {
				attributes.transform = CGAffineTransform.init(translationX: 0, y: -20)
			} else {
				attributes.transform = CGAffineTransform.identity
			}
		}
		return allAttributes
	}
}

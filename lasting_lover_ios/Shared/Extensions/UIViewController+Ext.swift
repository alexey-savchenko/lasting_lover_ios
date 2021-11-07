//
//  UIViewController+Ext.swift
//  lasting_lover_ios
//
//  Created by Alexey Savchenko on 07.11.2021.
//

import Foundation
import UIKit

extension UIViewController {
	func presentError(_ error: Error) {
		let c = UIAlertController(
			title: L10n.generalError,
			message: error.localizedDescription,
			preferredStyle: .alert
		)
		c.addAction(UIAlertAction(title: L10n.generalOk, style: UIAlertAction.Style.cancel))
		present(c, animated: true)
	}
}

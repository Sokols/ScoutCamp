//
//  UIViewController+Extensions.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 13/06/2023.
//

import UIKit

extension UIViewController {
    func showAlert(title: String = NSLocalizedString("General.AppName", comment: ""),
                   message: String,
                   actionName: String = NSLocalizedString("ok", comment: ""),
                   handler: ((UIAlertAction) -> Swift.Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: actionName, style: .default, handler: handler)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}

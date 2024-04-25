//
//  UIViewController+Extensions.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 25/04/2024.
//

import UIKit

extension UIViewController {
    var className: String {
        String(describing: Self.self)
    }
}

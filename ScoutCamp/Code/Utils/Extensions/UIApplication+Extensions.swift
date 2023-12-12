//
//  UIApplication+Extensions.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 05/12/2023.
//

import UIKit

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

//
//  String+Extensions.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 13/06/2023.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }

    func localized(arguments: CVarArg...) -> String {
        return String(format: self.localized, arguments: arguments)
    }
}

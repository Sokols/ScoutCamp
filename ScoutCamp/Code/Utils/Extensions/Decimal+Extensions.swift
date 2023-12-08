//
//  Decimal+Extensions.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 23/11/2023.
//

import Foundation

extension Decimal {
    private static var formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 2
        return formatter
    }()

    var pointsFormatted: String {
        let nsDecimalNumber = NSDecimalNumber(decimal: self)
        return Decimal.formatter.string(from: nsDecimalNumber) ?? ""
    }
}

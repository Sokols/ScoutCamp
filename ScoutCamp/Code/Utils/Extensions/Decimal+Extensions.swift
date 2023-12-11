//
//  Double+Extensions.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 23/11/2023.
//

import Foundation

extension Double {
    private static var formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        return formatter
    }()

    var pointsFormatted: String {
        return Double.formatter.string(for: self) ?? ""
    }
}

//
//  Date+Extensions.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 23/11/2023.
//

import Foundation

extension Date {

    private static let humanFormat = "MMM d, h:mm a"

    var sheetDate: String {
        getFormattedDate(format: Date.humanFormat)
    }

    private func getFormattedDate(
        format: String,
        locale: Locale = Locale(identifier: "en-US")
    ) -> String {
        let dateformat = DateFormatter()
        dateformat.locale = locale
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
}

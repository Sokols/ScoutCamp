//
//  Validation.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 16/06/2023.
//

import Foundation

class Validation {

    static let passwordMinChars = 8
    static let usernameMinChars = 6
    static let passwordMaxChars = 30
    static let usernameMaxChars = 30

    private static let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

    // MARK: - Contact information validation

    static func isRequiredFieldValid(_ text: String) -> Bool {
        return !text.isEmpty
    }

    static func isEmailValid(_ text: String) -> Bool {
        return isRegexValid(text, regex: emailRegex)
    }

    static func isUsernameCharsNumberValid(_ text: String) -> Bool {
        return isCharactersInRangeValid(text, minValue: usernameMinChars, maxValue: usernameMaxChars)
    }

    static func isPasswordCharsNumberValid(_ text: String) -> Bool {
        return isCharactersInRangeValid(text, minValue: passwordMinChars, maxValue: passwordMaxChars)
    }

    // MARK: Helpers

    private static func isCharactersInRangeValid(_ text: String, minValue: Int, maxValue: Int) -> Bool {
        return minValue...maxValue ~= text.count
    }

    private static func isRegexValid(_ text: String, regex: String) -> Bool {
        return NSPredicate.init(format: "SELF MATCHES %@", regex)
            .evaluate(with: text.trimmingCharacters(in: CharacterSet.whitespaces))
    }
}

//
//  Error.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 25/06/2023.
//

import Foundation

enum Error: LocalizedError {
    case generalError

    var errorDescription: String? {
        switch self {
        case .generalError:
            return "Error.GeneralError.Title"
        }
    }

    var recoverySuggestion: String? {
        switch self {
        case .generalError:
            return "Error.GeneralError.Message"
        }
    }
}

struct LocalizedAlertError: LocalizedError {
    let underlyingError: LocalizedError
    var errorDescription: String? {
        underlyingError.errorDescription?.localized
    }
    var recoverySuggestion: String? {
        underlyingError.recoverySuggestion?.localized
    }

    init?(error: Error?) {
        guard let localizedError = error else { return nil }
        underlyingError = localizedError
    }
}

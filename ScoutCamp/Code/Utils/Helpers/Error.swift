//
//  Error.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 25/06/2023.
//

import Foundation

typealias CheckCompletion = (_ isSuccess: Bool, _ error: Error?) -> Void

enum AppError: LocalizedError {
    case generalError

    var errorDescription: String {
        switch self {
        case .generalError:
            return "Error.GeneralError.Title"
        }
    }

    var recoverySuggestion: String {
        switch self {
        case .generalError:
            return "Error.GeneralError.Message"
        }
    }
}

struct LocalizedAlertError: LocalizedError {
    var errorDescription: String?
    var recoverySuggestion: String?

    init?(error: Error?) {
        guard let error = error else { return nil }
        errorDescription = "General.AppName".localized
        recoverySuggestion = error.localizedDescription
    }

    init?(error: AppError?) {
        guard let error = error else { return nil }
        errorDescription = error.errorDescription.localized
        recoverySuggestion = error.recoverySuggestion.localized
    }
}

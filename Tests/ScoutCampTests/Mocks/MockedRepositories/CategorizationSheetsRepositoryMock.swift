//
//  CategorizationSheetsRepositoryMock.swift
//  ScoutCampTests
//
//  Created by Igor SOKÓŁ on 10/05/2024.
//

import Foundation
@testable import ScoutCamp

final class CategorizationSheetsRepositoryMock: CategorizationSheetsRepository {

    enum CategorizationSheetsRepositoryMockError: Error {
        case failedFetching
    }

    private let isFailure: Bool
    private let sheets: [CategorizationSheet]

    init(isFailure: Bool, sheets: [CategorizationSheet]) {
        self.isFailure = isFailure
        self.sheets = sheets
    }

    func fetchCategorizationSheets() async -> Result<[CategorizationSheet], Error> {
        if isFailure {
            return .failure(CategorizationSheetsRepositoryMockError.failedFetching)
        }
        return .success(sheets)
    }
}

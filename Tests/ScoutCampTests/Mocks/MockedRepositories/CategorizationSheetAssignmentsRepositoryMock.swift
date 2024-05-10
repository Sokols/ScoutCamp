//
//  CategorizationSheetAssignmentsRepositoryMock.swift
//  ScoutCamp
//
//  Created by Igor SOKÓŁ on 10/05/2024.
//

import Foundation
@testable import ScoutCamp

final class CategorizationSheetAssignmentsRepositoryMock: CategorizationSheetAssignmentsRepository {

    enum CategorizationSheetAssignmentsRepositoryMockError: Error {
        case failedFetching
    }

    private let isFailure: Bool
    private let assignments: [CategorizationSheetAssignment]

    init(isFailure: Bool, assignments: [CategorizationSheetAssignment]) {
        self.isFailure = isFailure
        self.assignments = assignments
    }

    func fetchAssignments(for sheetId: String) async -> Result<[CategorizationSheetAssignment], Error> {
        if isFailure {
            return .failure(CategorizationSheetAssignmentsRepositoryMockError.failedFetching)
        }
        let result = assignments.filter { $0.categorizationSheetId == sheetId }
        return .success(result)
    }
}

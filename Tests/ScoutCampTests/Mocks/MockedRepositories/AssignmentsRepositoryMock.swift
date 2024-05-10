//
//  AssignmentsRepositoryMock.swift
//  ScoutCampTests
//
//  Created by Igor SOKÓŁ on 10/05/2024.
//

import Foundation
@testable import ScoutCamp

final class AssignmentsRepositoryMock: AssignmentsRepository {

    enum AssignmentsRepositoryMockError: Error {
        case failedFetching
    }

    private let isFailure: Bool
    private let assignments: [Assignment]

    init(isFailure: Bool, assignments: [Assignment]) {
        self.isFailure = isFailure
        self.assignments = assignments
    }

    func fetchAssignments(for ids: [String]) async -> Result<[Assignment], Error> {
        if isFailure {
            return .failure(AssignmentsRepositoryMockError.failedFetching)
        }
        let result = assignments.filter { ids.contains($0.id) }
        return .success(result)
    }
}

